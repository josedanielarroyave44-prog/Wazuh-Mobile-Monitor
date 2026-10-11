import 'package:wazuh_mobile_monitor/services/wazuh_api_service.dart';
import 'package:wazuh_mobile_monitor/services/wazuh_auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final WazuhAuthService authService;
  final WazuhApiService apiService;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  //Inyección de dependencias
  AuthRepository({required this.authService, required this.apiService});

  Future<String> authenticate({
    required String ip,
    required String username,
    required String password,
    required bool allowSelfSigned,
  }) async {
    try {
      // 1. Obtener el token
      String tokenJWT = await authService.login(
        ip: ip,
        username: username,
        password: password,
        allowSelfSigned: allowSelfSigned,
      );

      // 2. Guardar en local (Caché Segura) para futuras consultas
      await _secureStorage.write(key: 'jwt_token', value: tokenJWT);
      await _secureStorage.write(key: 'wazuh_ip', value: ip);
      await _secureStorage.write(key: 'wazuh_user', value: username);
      await _secureStorage.write(key: 'wazuh_password', value: password);
      await _secureStorage.write(
        key: 'allow_self_signed',
        value: allowSelfSigned.toString(),
      );

      // 3. Retornar el token para que el ViewModel sepa que hubo éxito
      return tokenJWT;
    } catch (e) {
      throw Exception("Error en el repositorio de autenticación: $e");
    }
  }

  // Métodos auxiliares
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'jwt_token');
  }

  Future<void> clearCredentials() async {
    await _secureStorage.deleteAll();
  }

  // ------------------------------------------------------------------
  // Interceptor de Peticiones
  // Este es el método que usan los ViewModels para pedirle datos a
  // Wazuh sin preocuparse por los tokens.
  // ------------------------------------------------------------------
  Future<dynamic> makeAuthenticatedRequest(String endpoint) async {
    try {
      String? currentToken = await _secureStorage.read(key: 'jwt_token');
      String? ip = await _secureStorage.read(key: 'wazuh_ip');
      String? allowSelfSignedStr = await _secureStorage.read(
        key: 'allow_self_signed',
      );

      if (currentToken == null || ip == null) {
        throw Exception("CRITICAL_AUTH_FAILURE: No token or IP available.");
      }

      bool allowSelfSigned = allowSelfSignedStr == 'true';

      return await apiService.get(
        ip: ip,
        endpoint: endpoint,
        token: currentToken,
        allowSelfSigned: allowSelfSigned,
      );
    } catch (e) {
      if (e.toString().contains("401_UNAUTHORIZED")) {
        return await _silentReauthAndRetry(endpoint);
      } else {
        rethrow;
      }
    }
  }

  // ------------------------------------------------------------------
  // REAUTENTICACIÓN SILENCIOSA
  // ------------------------------------------------------------------
  Future<dynamic> _silentReauthAndRetry(String endpoint) async {
    try {
      // 1. Extraer credenciales almacenadas del Keystore de forma invisible
      String? ip = await _secureStorage.read(key: 'wazuh_ip');
      String? user = await _secureStorage.read(key: 'wazuh_user');
      String? pass = await _secureStorage.read(key: 'wazuh_password');
      String? allowSelfSignedStr = await _secureStorage.read(
        key: 'allow_self_signed',
      );

      if (ip == null || user == null || pass == null) {
        throw Exception("Incomplete credentials in secure storage");
      }

      bool allowSelfSigned = allowSelfSignedStr == 'true';

      // 2. Re-negociar un token fresco
      String newToken = await authService.login(
        ip: ip,
        username: user,
        password: pass,
        allowSelfSigned: allowSelfSigned,
      );

      // 3. Guardar el nuevo token
      await _secureStorage.write(key: 'jwt_token', value: newToken);

      // 4. Reintentar la petición original real con el NUEVO token
      return await apiService.get(
        ip: ip,
        endpoint: endpoint,
        token: newToken,
        allowSelfSigned: allowSelfSigned,
      );
    } catch (error) {
      // PASO 4: EL KILL SWITCH (Zero Trust)
      // Si la reautenticación silenciosa falla (ej. el admin cambió su clave
      // desde el servidor), destruimos inmediatamente las credenciales locales
      // y obligamos a la aplicación a devolver al usuario al Login.
      await clearCredentials();
      throw Exception(
        "CRITICAL_AUTH_FAILURE: Revoked or invalid credentials. $error",
      );
    }
  }
}

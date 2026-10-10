import 'package:wazuh_mobile_monitor/services/wazuh_auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final WazuhAuthService authService;
  // Instanciación del almacenamiento seguro
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  //Inyección de dependencias
  AuthRepository({required this.authService});

  Future<String> authenticate({
    required String ip,
    required String username,
    required String password,
    required bool allowSelfSigned,
  }) async {
    try {
      // 1. Obtener el token desde el servicio de red (Remote Data Source)
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
}

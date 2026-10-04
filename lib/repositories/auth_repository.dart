import 'package:wazuh_mobile_monitor/services/wazuh_auth_service.dart';

class AuthRepository {
  final WazuhAuthService authService;
  AuthRepository({required this.authService});

  Future<String> authenticate({
    required String ip,
    required String username,
    required String password,
    required bool allowSelfSigned,
  }) async {
    try {
      String token = await authService.login(
        ip: ip,
        username: username,
        password: password,
        allowSelfSigned: allowSelfSigned,
      );
      return token;
    } catch (e) {
      throw Exception("Error en el repositorio de autenticación: $e");
    } //try-catch block
  } //authenticate
} //class

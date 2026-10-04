import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';

class WazuhAuthService {
  //Devuelve Token JWT
  Future<String> login({
    required String ip,
    required String username,
    required String password,
    required bool allowSelfSigned,
  }) async {
    final Uri url = Uri.parse('https://$ip:55000/security/user/authenticate');

    final String userAuth = '$username:$password';
    final userAuthBase64 = base64Encode(utf8.encode(userAuth));

    final Map<String, String> httpAuthHeader = {
      'Authorization': 'Basic $userAuthBase64',
    };

    try {
      http.Client client;

      if (allowSelfSigned) {
        final httpClient = HttpClient()
          ..badCertificateCallback = ((
            X509Certificate cert,
            String host,
            int port,
          ) => true);

        client = IOClient(httpClient);
      } else {
        client = http.Client();
      }

      final response = await client.post(url, headers: httpAuthHeader);
      client.close();
      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
        final dataJSON = decodedBody['data'];

        if (dataJSON is! Map<String, dynamic>) {
          throw const FormatException('Invalid authentication response');
        }

        final String tokenJWT = dataJSON['token'] as String;
        return tokenJWT;
      } else {
        throw Exception('Error al autenticar: Error ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error al autenticar: $error');
    } //try-catch block
  } //login
} //class

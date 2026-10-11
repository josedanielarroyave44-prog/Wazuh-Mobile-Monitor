import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class WazuhApiService {
  // Método genérico para hacer peticiones GET a Wazuh
  Future<dynamic> get({
    required String ip,
    required String endpoint,
    required String token,
    required bool allowSelfSigned,
  }) async {
    final Uri url = Uri.parse('https://$ip:55000$endpoint');

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

    final response = await client.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    client.close();

    if (response.statusCode == 401) {
      // Lanzamos el error específico para que el Repositorio lo intercepte
      throw const FormatException("401_UNAUTHORIZED");
    } else if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        "Error del servidor Wazuh: Código ${response.statusCode}",
      );
    }
  }
}

// FILE: lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await client
          .get(
            Uri.parse(endpoint),
            headers: ApiConfig.headers,
          )
          .timeout(
            const Duration(seconds: ApiConfig.connectionTimeout),
          );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, dynamic data) async {
    try {
      final response = await client
          .post(
            Uri.parse(endpoint),
            headers: ApiConfig.headers,
            body: jsonEncode(data),
          )
          .timeout(
            const Duration(seconds: ApiConfig.connectionTimeout),
          );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur ${response.statusCode}: ${response.body}');
    }
  }

  void dispose() {
    client.close();
  }
}
// FILE: lib/config/api_config.dart

class ApiConfig {
  // Base URL de votre API REST
  static const String baseUrl = 'https://votre-api.com/api';
  
  // Endpoints
  static const String trajets = '$baseUrl/trajets';
  static const String villes = '$baseUrl/villes';
  static const String horaires = '$baseUrl/horaires';
  static const String reservations = '$baseUrl/reservations';
  
  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Timeout en secondes
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;
}
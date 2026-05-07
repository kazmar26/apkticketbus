// FILE: lib/services/trajet_service.dart

import 'package:voyage_reservation_app/models/trajet.dart';
import 'package:voyage_reservation_app/models/ville.dart';
import 'api_service.dart';
import '../config/api_config.dart';

class TrajetService {
  final ApiService _apiService;

  TrajetService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  Future<List<Trajet>> getTrajetsDisponibles() async {
    try {
      final response = await _apiService.get(ApiConfig.trajets);
      
      if (response['data'] != null && response['data'] is List) {
        return (response['data'] as List)
            .map((item) => Trajet.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Erreur lors du chargement des trajets: $e');
    }
  }

  Future<List<Trajet>> getTrajetsParDepart(String villeDepart) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.trajets}?depart=$villeDepart'
      );
      
      if (response['data'] != null && response['data'] is List) {
        return (response['data'] as List)
            .map((item) => Trajet.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Erreur lors du chargement des trajets: $e');
    }
  }

  Future<Trajet?> getTrajetById(int id) async {
    try {
      final response = await _apiService.get('${ApiConfig.trajets}/$id');
      
      if (response['data'] != null) {
        return Trajet.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors du chargement du trajet: $e');
    }
  }

  Future<List<Ville>> getVilles() async {
    try {
      final response = await _apiService.get(ApiConfig.villes);
      
      if (response['data'] != null && response['data'] is List) {
        return (response['data'] as List)
            .map((item) => Ville.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Erreur lors du chargement des villes: $e');
    }
  }

  Future<bool> verifierDisponibilite(int trajetId, int nombrePlaces) async {
    try {
      final trajet = await getTrajetById(trajetId);
      if (trajet != null) {
        return trajet.placesDisponibles >= nombrePlaces;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
// FILE: lib/services/reservation_service.dart

import 'package:voyage_reservation_app/models/reservation.dart';
import 'api_service.dart';
import '../config/api_config.dart';

class ReservationService {
  final ApiService _apiService;

  ReservationService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  Future<Reservation> creerReservation(Reservation reservation) async {
    try {
      final response = await _apiService.post(
        ApiConfig.reservations,
        reservation.toJson(),
      );
      
      if (response['data'] != null) {
        return Reservation.fromJson(response['data']);
      }
      throw Exception('Erreur lors de la création de la réservation');
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  Future<List<Reservation>> getReservationsByTelephone(String telephone) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.reservations}?telephone=$telephone'
      );
      
      if (response['data'] != null && response['data'] is List) {
        return (response['data'] as List)
            .map((item) => Reservation.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Erreur lors du chargement des réservations: $e');
    }
  }

  Future<Reservation?> getReservationByCode(String code) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.reservations}?code=$code'
      );
      
      if (response['data'] != null && response['data'] is List && response['data'].isNotEmpty) {
        return Reservation.fromJson(response['data'][0]);
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors du chargement de la réservation: $e');
    }
  }

  Future<bool> annulerReservation(int reservationId) async {
    try {
      final response = await _apiService.post(
        '${ApiConfig.reservations}/$reservationId/annuler',
        {},
      );
      return response['success'] == true;
    } catch (e) {
      throw Exception('Erreur lors de l\'annulation: $e');
    }
  }
}
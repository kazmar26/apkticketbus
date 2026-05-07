// FILE: lib/providers/reservation_provider.dart

import 'package:flutter/material.dart';
import '../models/reservation.dart';
import '../models/trajet.dart';
import '../services/reservation_service.dart';
import 'trajet_provider.dart';

class ReservationProvider extends ChangeNotifier {
  final ReservationService _reservationService = ReservationService();
  
  List<Reservation> _mesReservations = [];
  Reservation? _currentReservation;
  bool _isLoading = false;
  String? _errorMessage;

  List<Reservation> get mesReservations => _mesReservations;
  Reservation? get currentReservation => _currentReservation;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> creerReservation({
    required Trajet trajet,
    required String nomClient,
    required String telephone,
    String? email,
    required int nombrePlaces,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final montantTotal = trajet.prix * nombrePlaces;
      
      final reservation = Reservation(
        trajetId: trajet.id,
        nomClient: nomClient,
        telephone: telephone,
        email: email,
        nombrePlaces: nombrePlaces,
        dateReservation: DateTime.now(),
        montantTotal: montantTotal.toDouble(),
      );

      _currentReservation = await _reservationService.creerReservation(reservation);
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMesReservations(String telephone) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _mesReservations = await _reservationService.getReservationsByTelephone(telephone);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> annulerReservation(int reservationId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _reservationService.annulerReservation(reservationId);
      if (result) {
        await loadMesReservations(_mesReservations.first.telephone);
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetCurrentReservation() {
    _currentReservation = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
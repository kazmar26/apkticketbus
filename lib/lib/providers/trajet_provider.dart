// FILE: lib/providers/trajet_provider.dart

import 'package:flutter/material.dart';
import '../models/trajet.dart';
import '../models/ville.dart';
import '../services/trajet_service.dart';

class TrajetProvider extends ChangeNotifier {
  final TrajetService _trajetService = TrajetService();
  
  List<Trajet> _trajets = [];
  List<Trajet> _trajetsFiltres = [];
  List<Ville> _villes = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _villeDepartFiltre = 'Lubumbashi';

  List<Trajet> get trajets => _trajetsFiltres.isEmpty ? _trajets : _trajetsFiltres;
  List<Ville> get villes => _villes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get villeDepartFiltre => _villeDepartFiltre;

  Future<void> loadTrajets() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _trajets = await _trajetService.getTrajetsDisponibles();
      _appliquerFiltre();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadVilles() async {
    try {
      _villes = await _trajetService.getVilles();
      notifyListeners();
    } catch (e) {
      print('Erreur chargement villes: $e');
    }
  }

  void filtrerParVilleDepart(String ville) {
    _villeDepartFiltre = ville;
    _appliquerFiltre();
  }

  void _appliquerFiltre() {
    if (_villeDepartFiltre.isEmpty) {
      _trajetsFiltres = [];
    } else {
      _trajetsFiltres = _trajets
          .where((trajet) => 
              trajet.villeDepart == _villeDepartFiltre &&
              trajet.estDisponible)
          .toList();
    }
    notifyListeners();
  }

  Trajet? getTrajetById(int id) {
    return _trajets.firstWhere(
      (trajet) => trajet.id == id,
      orElse: () => throw Exception('Trajet non trouvé'),
    );
  }

  Future<bool> verifierDisponibilite(int trajetId, int nombrePlaces) async {
    return await _trajetService.verifierDisponibilite(trajetId, nombrePlaces);
  }

  Future<void> refresh() async {
    await loadTrajets();
    await loadVilles();
  }
}
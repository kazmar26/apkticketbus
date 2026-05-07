// FILE: lib/models/reservation.dart

import 'package:flutter/material.dart';

class Reservation {
  final int? id;
  final int trajetId;
  final String nomClient;
  final String telephone;
  final String? email;
  final int nombrePlaces;
  final DateTime dateReservation;
  final String statut;
  final double montantTotal;
  final String? codeReservation;

  Reservation({
    this.id,
    required this.trajetId,
    required this.nomClient,
    required this.telephone,
    this.email,
    required this.nombrePlaces,
    required this.dateReservation,
    this.statut = 'en_attente',
    required this.montantTotal,
    this.codeReservation,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      trajetId: json['trajet_id'] ?? 0,
      nomClient: json['nom_client'] ?? '',
      telephone: json['telephone'] ?? '',
      email: json['email'],
      nombrePlaces: json['nombre_places'] ?? 1,
      dateReservation: DateTime.parse(json['date_reservation'] ?? DateTime.now().toIso8601String()),
      statut: json['statut'] ?? 'en_attente',
      montantTotal: (json['montant_total'] ?? 0).toDouble(),
      codeReservation: json['code_reservation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trajet_id': trajetId,
      'nom_client': nomClient,
      'telephone': telephone,
      'email': email,
      'nombre_places': nombrePlaces,
      'date_reservation': dateReservation.toIso8601String(),
      'statut': statut,
      'montant_total': montantTotal,
      'code_reservation': codeReservation,
    };
  }

  String get statutLibelle {
    switch (statut) {
      case 'en_attente':
        return 'En attente';
      case 'confirmee':
        return 'Confirmée';
      case 'annulee':
        return 'Annulée';
      default:
        return statut;
    }
  }

  Color get statutColor {
    switch (statut) {
      case 'en_attente':
        return Colors.orange;
      case 'confirmee':
        return Colors.green;
      case 'annulee':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
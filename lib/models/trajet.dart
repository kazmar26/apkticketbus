// FILE: lib/models/trajet.dart

class Trajet {
  final int id;
  final String villeDepart;
  final String villeArrivee;
  final String heureDepart;
  final String gareDepart;
  final int dureeEstimeeMinutes;
  final int placesDisponibles;
  final int prix;
  final DateTime? dateTrajet;

  Trajet({
    required this.id,
    required this.villeDepart,
    required this.villeArrivee,
    required this.heureDepart,
    required this.gareDepart,
    required this.dureeEstimeeMinutes,
    required this.placesDisponibles,
    required this.prix,
    this.dateTrajet,
  });

  factory Trajet.fromJson(Map<String, dynamic> json) {
    return Trajet(
      id: json['id'] ?? 0,
      villeDepart: json['ville_depart'] ?? '',
      villeArrivee: json['ville_arrivee'] ?? '',
      heureDepart: json['heure_depart'] ?? '00:00',
      gareDepart: json['gare_depart'] ?? '',
      dureeEstimeeMinutes: json['duree_estimee'] ?? 0,
      placesDisponibles: json['places_disponibles'] ?? 0,
      prix: json['prix'] ?? 0,
      dateTrajet: json['date_trajet'] != null 
          ? DateTime.parse(json['date_trajet']) 
          : null,
    );
  }

  String get dureeFormatee {
    int heures = dureeEstimeeMinutes ~/ 60;
    int minutes = dureeEstimeeMinutes % 60;
    if (heures > 0 && minutes > 0) {
      return '${heures}h ${minutes}min';
    } else if (heures > 0) {
      return '${heures}h';
    } else {
      return '${minutes}min';
    }
  }

  String get prixFormate => '${prix.toString()} FC';

  bool get estDisponible => placesDisponibles > 0;
  
  String get statusDisponibilite {
    if (placesDisponibles > 20) return 'Beaucoup de places';
    if (placesDisponibles > 5) return 'Places limitées';
    if (placesDisponibles > 0) return 'Dernières places';
    return 'Complet';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ville_depart': villeDepart,
      'ville_arrivee': villeArrivee,
      'heure_depart': heureDepart,
      'gare_depart': gareDepart,
      'duree_estimee': dureeEstimeeMinutes,
      'places_disponibles': placesDisponibles,
      'prix': prix,
      'date_trajet': dateTrajet?.toIso8601String(),
    };
  }
}
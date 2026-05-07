// FILE: lib/models/ville.dart

class Ville {
  final int id;
  final String nom;
  final String? code;

  Ville({
    required this.id,
    required this.nom,
    this.code,
  });

  factory Ville.fromJson(Map<String, dynamic> json) {
    return Ville(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'code': code,
    };
  }

  @override
  String toString() => nom;
}
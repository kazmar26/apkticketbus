// FILE: lib/widgets/trajet_card.dart

import 'package:flutter/material.dart';
import '../models/trajet.dart';
import '../config/app_colors.dart';

class TrajetCard extends StatelessWidget {
  final Trajet trajet;
  final VoidCallback onReserver;

  const TrajetCard({
    Key? key,
    required this.trajet,
    required this.onReserver,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surface,
              AppColors.surface.withOpacity(0.95),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildVilleInfo(
                      trajet.villeDepart,
                      trajet.heureDepart,
                      Icons.trip_origin,
                    ),
                  ),
                  const Icon(Icons.arrow_forward, color: AppColors.primary),
                  Expanded(
                    child: _buildVilleInfo(
                      trajet.villeArrivee,
                      _calculerHeureArrivee(trajet.heureDepart, trajet.dureeEstimeeMinutes),
                      Icons.location_on,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                      Icons.schedule,
                      'Durée: ${trajet.dureeFormatee}',
                      Icons.place,
                      trajet.gareDepart,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.event_seat,
                      'Places: ${trajet.placesDisponibles} disponibles',
                      Icons.attach_money,
                      trajet.prixFormate,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: trajet.estDisponible 
                          ? AppColors.success.withOpacity(0.2)
                          : AppColors.error.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      trajet.estDisponible ? 'Disponible' : 'Complet',
                      style: TextStyle(
                        color: trajet.estDisponible ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: trajet.estDisponible ? onReserver : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: AppColors.textLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    ),
                    child: const Text('RÉSERVER'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVilleInfo(String ville, String heure, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 4),
        Text(
          ville,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          heure,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon1, String text1, IconData icon2, String text2) {
    return Row(
      children: [
        Icon(icon1, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(text1, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const Spacer(),
        Icon(icon2, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(text2, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }

  String _calculerHeureArrivee(String heureDepart, int dureeMinutes) {
    try {
      final parts = heureDepart.split(':');
      int heures = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      
      int totalMinutes = heures * 60 + minutes + dureeMinutes;
      int heuresArrivee = (totalMinutes ~/ 60) % 24;
      int minutesArrivee = totalMinutes % 60;
      
      return '${heuresArrivee.toString().padLeft(2, '0')}:${minutesArrivee.toString().padLeft(2, '0')}';
    } catch (e) {
      return '--:--';
    }
  }
}
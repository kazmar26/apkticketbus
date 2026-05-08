// FILE: lib/screens/mes_reservations_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reservation_provider.dart';
import '../models/reservation.dart';
import '../config/app_colors.dart';

class MesReservationsScreen extends StatefulWidget {
  const MesReservationsScreen({Key? key}) : super(key: key);

  @override
  State<MesReservationsScreen> createState() => _MesReservationsScreenState();
}

class _MesReservationsScreenState extends State<MesReservationsScreen> {
  final _telephoneController = TextEditingController();
  bool _hasSearched = false;

  @override
  void dispose() {
    _telephoneController.dispose();
    super.dispose();
  }

  Future<void> _searchReservations() async {
    if (_telephoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer votre numéro de téléphone'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _hasSearched = true;
    });

    final provider = Provider.of<ReservationProvider>(context, listen: false);
    await provider.loadMesReservations(_telephoneController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MES RÉSERVATIONS'),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  controller: _telephoneController,
                  decoration: InputDecoration(
                    labelText: 'Numéro de téléphone',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _telephoneController.clear();
                        setState(() {
                          _hasSearched = false;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _searchReservations,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('RECHERCHER MES RÉSERVATIONS'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<ReservationProvider>(
              builder: (context, provider, child) {
                if (!_hasSearched) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Entrez votre numéro de téléphone\npour voir vos réservations',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: AppColors.error),
                        const SizedBox(height: 16),
                        Text(
                          provider.errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.error),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.mesReservations.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Aucune réservation trouvée',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Vérifiez votre numéro de téléphone',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _searchReservations,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.mesReservations.length,
                    itemBuilder: (context, index) {
                      final reservation = provider.mesReservations[index];
                      return _ReservationCard(
                        reservation: reservation,
                        onAnnuler: () => _confirmAnnulation(reservation),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAnnulation(Reservation reservation) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Annuler la réservation'),
        content: const Text(
          'Êtes-vous sûr de vouloir annuler cette réservation ? '
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('NON'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('OUI, ANNULER'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final provider = Provider.of<ReservationProvider>(context, listen: false);
      final success = await provider.annulerReservation(reservation.id!);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Réservation annulée' : 'Erreur lors de l\'annulation',
            ),
            backgroundColor: success ? AppColors.success : AppColors.error,
          ),
        );
        if (success) {
          await provider.loadMesReservations(_telephoneController.text.trim());
        }
      }
    }
  }
}

class _ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final VoidCallback onAnnuler;

  const _ReservationCard({
    required this.reservation,
    required this.onAnnuler,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Trajet #${reservation.trajetId}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: reservation.statutColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    reservation.statutLibelle,
                    style: TextStyle(
                      color: reservation.statutColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.code, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Code: ${reservation.codeReservation ?? 'N/A'}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(reservation.nomClient),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.event_seat, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('${reservation.nombrePlaces} place(s)'),
                const Spacer(),
                const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${reservation.montantTotal.toStringAsFixed(0)} FC',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(_formatDate(reservation.dateReservation)),
              ],
            ),
            if (reservation.statut != 'annulee') ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onAnnuler,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    foregroundColor: AppColors.error,
                  ),
                  child: const Text('ANNULER LA RÉSERVATION'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} à ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
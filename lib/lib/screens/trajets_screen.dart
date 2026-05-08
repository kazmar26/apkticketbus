// FILE: lib/screens/trajets_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/trajet_provider.dart';
import '../widgets/trajet_card.dart';
import '../widgets/loading_widget.dart';
import '../config/app_colors.dart';
import 'reservation_screen.dart';

class TrajetsScreen extends StatefulWidget {
  const TrajetsScreen({Key? key}) : super(key: key);

  @override
  State<TrajetsScreen> createState() => _TrajetsScreenState();
}

class _TrajetsScreenState extends State<TrajetsScreen> {
  String _selectedVille = 'Lubumbashi';
  final List<String> _villesPrincipales = [
    'Lubumbashi',
    'Kamina',
    'Kolwezi',
    'Likasi',
    'Mbuji-Mayi',
    'Kinshasa',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final provider = Provider.of<TrajetProvider>(context, listen: false);
    await provider.loadTrajets();
    provider.filtrerParVilleDepart(_selectedVille);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VOTRE TRAJET, VOS CHOIX !'),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 2,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, Color(0xFF2A5298)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'Sélectionnez votre trajet et réservez en toute simplicité',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedVille,
                      icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                      isExpanded: true,
                      items: _villesPrincipales.map((String ville) {
                        return DropdownMenuItem<String>(
                          value: ville,
                          child: Text(
                            'Départ: $ville',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedVille = newValue;
                          });
                          final provider = Provider.of<TrajetProvider>(
                            context,
                            listen: false,
                          );
                          provider.filtrerParVilleDepart(_selectedVille);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<TrajetProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const LoadingWidget();
                }

                if (provider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          provider.errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.error),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _loadData(),
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.trajets.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_bus,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun trajet disponible pour $_selectedVille',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: provider.trajets.length,
                    itemBuilder: (context, index) {
                      final trajet = provider.trajets[index];
                      return TrajetCard(
                        trajet: trajet,
                        onReserver: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReservationScreen(
                                trajet: trajet,
                              ),
                            ),
                          );
                        },
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
}
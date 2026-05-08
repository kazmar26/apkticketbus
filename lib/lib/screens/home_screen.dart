// FILE: lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/trajet_provider.dart';
import '../providers/reservation_provider.dart';
import '../config/app_colors.dart';
import 'trajets_screen.dart';
import 'mes_reservations_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? _searchTelephone;

  final List<Widget> _screens = [
    const TrajetsScreen(),
    const MesReservationsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _initialLoad();
  }

  Future<void> _initialLoad() async {
    final trajetProvider = Provider.of<TrajetProvider>(context, listen: false);
    await trajetProvider.loadTrajets();
    await trajetProvider.loadVilles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          selectedItemColor: AppColors.secondary,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_bus),
              label: 'Trajets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'Mes réservations',
            ),
          ],
        ),
      ),
    );
  }
}
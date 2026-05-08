import 'package:flutter/material.dart';

class ReservationScreen extends StatefulWidget {
  final dynamic trajet;
  const ReservationScreen({Key? key, required this.trajet}) : super(key: key);

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _telephoneController = TextEditingController();
  int _nombrePlaces = 1;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Réservation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (v) => v!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _telephoneController,
                decoration: const InputDecoration(labelText: 'Téléphone'),
                validator: (v) => v!.isEmpty ? 'Champ requis' : null,
              ),
              Row(children: [
                const Text('Places:'),
                IconButton(onPressed: () => setState(() => _nombrePlaces--), icon: const Icon(Icons.remove)),
                Text('$_nombrePlaces'),
                IconButton(onPressed: () => setState(() => _nombrePlaces++), icon: const Icon(Icons.add)),
              ]),
              ElevatedButton(
                onPressed: _isLoading ? null : () {
                  setState(() => _isLoading = true);
                  Future.delayed(const Duration(seconds: 1), () {
                    setState(() => _isLoading = false);
                    // Retour
                  });
                },
                child: _isLoading ? const CircularProgressIndicator() : const Text('Confirmer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Benutzername'),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Passwort'),
            obscureText: true, // Passwortfeld ausblenden
          ),
        ],
      ),
    );
  }
}

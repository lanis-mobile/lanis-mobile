import 'package:flutter/material.dart';
import 'package:sph_plan/client/client.dart';

import '../../../client/storage.dart';

class LoadModeScreen extends StatefulWidget {
  const LoadModeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoadModeScreenState();
}

class _LoadModeScreenState extends State<LoadModeScreen> {
  String _selectedMode = "full"; // Default theme

  Future<void> _applyMode(String mode) async {
    await globalStorage.write(key: "loadMode", value: mode);
    _selectedMode = mode;
    client.loadMode = mode;
  }

  @override
  void initState() {
    super.initState();
    _selectedMode = client.loadMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lademodus"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioListTile(
              title: const Text('Alles laden'),
              subtitle: const Text('Dauert ein bisschen länger, aber du kannst alle Daten des Schulportals direkt sehen, ohne immer einen Ladebildschirm zu haben. Außerdem werden alle 15 Minuten Daten neu geladen.'),
              value: "full",
              groupValue: _selectedMode,
              onChanged: (value) {
                setState(() {
                  _selectedMode = value.toString();
                  _applyMode(_selectedMode);
                });
              },
            ),
            RadioListTile(
              title: const Text('Nur Vertretungsplan laden'),
              subtitle: const Text("Ist schneller, aber beim Angucken andere Daten müssen sie zuerst geladen werden, was immer zuerst einen Ladebildschirm zeigt. Nützlich wenn man so schnell wie möglich den Vertretungsplan sehen möchte."),
              value: "fast",
              groupValue: _selectedMode,
              onChanged: (value) {
                setState(() {
                  _selectedMode = value.toString();
                  _applyMode(_selectedMode);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

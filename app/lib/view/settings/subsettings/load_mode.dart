import 'package:flutter/material.dart';
import 'package:sph_plan/client/client.dart';

import '../../../client/storage.dart';

class LoadModeScreen extends StatelessWidget {
  const LoadModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Lademodus"),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: LoadModeElements(),
        )
    );
  }
}

class LoadModeElements extends StatefulWidget {
  const LoadModeElements({super.key});

  @override
  State<LoadModeElements> createState() => _LoadModeElementsState();
}

class _LoadModeElementsState extends State<LoadModeElements> {
  String _selectedMode = "fast"; // Default theme

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RadioListTile(
          title: const Text('Nur Vertretungsplan laden'),
          subtitle: const Text("Ist schneller, aber beim Angucken anderer Daten müssen sie zuerst geladen werden, was immer zuerst einen Ladebalken zeigt. Nützlich wenn man so schnell wie möglich den Vertretungsplan sehen möchte. Außerdem spart es Daten für dich und Lanis. Empfohlen für die meisten Nutzer."),
          value: "fast",
          groupValue: _selectedMode,
          onChanged: (value) {
            setState(() {
              _selectedMode = value.toString();
              _applyMode(_selectedMode);
            });
          },
        ),
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
      ],
    );
  }
}


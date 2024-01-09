import 'package:flutter/material.dart';
import 'package:sph_plan/client/storage.dart';
import 'package:sph_plan/themes.dart';

class AppearanceSettingsScreen extends StatelessWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Aussehen"),
        ),
        body: const AppearanceElements()
    );
  }
}

class AppearanceElements extends StatefulWidget {
  const AppearanceElements({super.key});

  @override
  State<AppearanceElements> createState() => _AppearanceElementsState();
}

class _AppearanceElementsState extends State<AppearanceElements> {
  String _selectedTheme = "system"; // Default theme
  String _selectedColor = "standard"; // Default color

  @override
  void initState() {
    super.initState();
    // Idk if prefs is the right way but it's working.
    _selectedTheme = globalStorage.prefs.getString("theme") ?? "system";
    _selectedColor = globalStorage.prefs.getString("color") ?? "standard";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Theme Mode, aka light or dark mode
          ...[
            Text(
              "Theme",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            RadioListTile(
              title: const Text('Light Mode'),
              value: "light",
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value.toString();
                  ThemeModeNotifier.set(_selectedTheme);
                });
              },
            ),
            RadioListTile(
              title: const Text('Dark Mode'),
              value: "dark",
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value.toString();
                  ThemeModeNotifier.set(_selectedTheme);
                });
              },
            ),
            RadioListTile(
              title: const Text('System Mode'),
              value: "system",
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value.toString();
                  ThemeModeNotifier.set(_selectedTheme);
                });
              },
            ),
          ],
          const Divider(),
          // Color mode, aka the primary color accent of the app
          ...[
            Text(
              "Farbe",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            RadioListTile(
              title: const Text('Standart'),
              subtitle: const Text('Lanis-Dunkel-Türkis'),
              value: "standard",
              groupValue: _selectedColor,
              onChanged: (value) {
                setState(() {
                  _selectedColor = value.toString();
                  ColorModeNotifier.setStandard();
                });
              },
            ),
            RadioListTile(
              title: const Text('Dynamisch'),
              subtitle: const Text('Hier wird die Farbe von deinem Hintergrundsbild benutzt, auch bekannt als "Material You". Wird nicht von allen Geräten unterstützt.'),
              value: "dynamic",
              groupValue: _selectedColor,
              onChanged: Themes.dynamicTheme.lightTheme == null ? null : (value) {
                setState(() {
                  _selectedColor = value.toString();
                  ColorModeNotifier.setDynamic();
                });
              },
            ),
          ]
        ],
      ),
    );
  }
}
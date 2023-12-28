import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class AppearanceSettingsScreen extends StatelessWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Appearance"),
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

  void _applyTheme(String theme) {
    switch (theme) {
      case "light":
        AdaptiveTheme.of(context).setLight();
        break;
      case "dark":
        AdaptiveTheme.of(context).setDark();
        break;
      case "system":
        AdaptiveTheme.of(context).setSystem();
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedTheme = AdaptiveTheme.of(context).mode.name;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RadioListTile(
            title: const Text('Light Mode'),
            value: "light",
            groupValue: _selectedTheme,
            onChanged: (value) {
              setState(() {
                _selectedTheme = value.toString();
                _applyTheme(_selectedTheme);
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
                _applyTheme(_selectedTheme);
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
                _applyTheme(_selectedTheme);
              });
            },
          ),
        ],
      ),
    );
  }
}


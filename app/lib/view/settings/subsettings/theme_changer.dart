import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class AppearanceSettingsScreen extends StatefulWidget {
  const AppearanceSettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppearanceSettingsScreenState();
}

class _AppearanceSettingsScreenState extends State<AppearanceSettingsScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appearance"),
      ),
      body: Padding(
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
      ),
    );
  }
}

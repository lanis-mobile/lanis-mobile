import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
        body: ListView(
            children: const [
              AppearanceElements()
            ],
        )
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

  RadioListTile colorListTile({required String title, required String value, Color? primaryColor, String? subtitle, Function? callOnChanged}) {
    return RadioListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      secondary: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).colorScheme.onSurface,
                width: 2
            ),
            borderRadius: BorderRadius.circular(12)
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: primaryColor ?? (
                Theme.of(context).brightness == Brightness.dark
                    ? Themes.flutterColorThemes[value]!.darkTheme!.colorScheme.primary
                    : Themes.flutterColorThemes[value]!.lightTheme!.colorScheme.primary
            ),
          ),
        ),
      ),
      value: value,
      groupValue: _selectedColor,
      onChanged: (value) {
        setState(() {
          _selectedColor = value.toString();
          if (callOnChanged == null) {
            ColorModeNotifier.set(value);
          } else {
            callOnChanged();
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<RadioListTile> flutterColorRadioListTiles = [];

    for (String name in Themes.flutterColorThemes.keys) {
      if (name == "standard") continue; // We already have standard

      flutterColorRadioListTiles.add(
        colorListTile(
            title: toBeginningOfSentenceCase(name)!,
            value: name
        )
      );
    }

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
            colorListTile(
              title: "Standart",
              subtitle: 'Dunkellila',
              value: "standard",
                primaryColor: Theme.of(context).brightness == Brightness.dark
                    ? Themes.standardTheme.darkTheme!.colorScheme.primary
                    : Themes.standardTheme.lightTheme!.colorScheme.primary,
              callOnChanged: ColorModeNotifier.setStandard
            ),
            RadioListTile(
              title: const Text("Dynamisch"),
              subtitle: const Text('Hier wird die Farbe von deinem Hintergrundbild benutzt, auch bekannt als "Material You". Wird nicht von allen Geräten unterstützt.'),
              secondary: Themes.dynamicTheme.lightTheme == null ? null
                  : Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 2
                    ),
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Column(
                  children: [
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Themes.dynamicTheme.darkTheme!.colorScheme.primary
                              : Themes.dynamicTheme.lightTheme!.colorScheme.primary,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Themes.dynamicTheme.darkTheme!.colorScheme.secondary
                              : Themes.dynamicTheme.lightTheme!.colorScheme.secondary,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              value: "dynamic",
              groupValue: _selectedColor,
              onChanged: Themes.dynamicTheme.lightTheme == null ? null : (value) {
                setState(() {
                  _selectedColor = value.toString();
                  ColorModeNotifier.setDynamic();
                });
              },
            ),
            colorListTile(
              title: "Schulfarbe",
              subtitle: "Hier wird die Hauptfarbe von Lanis benutzt, was meistens eine Form von blau oder türkis ist.",
              value: "school",
              primaryColor: Theme.of(context).brightness == Brightness.dark
                  ? Themes.schoolTheme.darkTheme!.colorScheme.primary
                  : Themes.schoolTheme.lightTheme!.colorScheme.primary,
              callOnChanged: ColorModeNotifier.setSchool
            ),
          ],
          const Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Divider(),
          ),
          ...flutterColorRadioListTiles
        ],
      ),
    );
  }
}
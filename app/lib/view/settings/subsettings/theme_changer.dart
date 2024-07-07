import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/client/storage.dart';
import 'package:sph_plan/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../main.dart';

class AppearanceSettingsScreen extends StatelessWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.appearance),
        ),
        body: ListView(
          children: const [AppearanceElements()],
        ));
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

  RadioListTile colorListTile(
      {required String title,
      required String value,
      Color? primaryColor,
      String? subtitle}) {
    return RadioListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      secondary: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).colorScheme.onSurface, width: 2),
            borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: primaryColor ??
                (Theme.of(context).brightness == Brightness.dark
                    ? Themes.flutterColorThemes[value]!.darkTheme!.colorScheme
                        .primary
                    : Themes.flutterColorThemes[value]!.lightTheme!.colorScheme
                        .primary),
          ),
        ),
      ),
      value: value,
      groupValue: _selectedColor,
      onChanged: (value) {
        setState(() {
          _selectedColor = value.toString();
          if (value == "standard") {
            ColorModeNotifier.set("standard", Themes.standardTheme);
          } else if (value == "school") {
            ColorModeNotifier.set("school", Themes.schoolTheme);
          } else {
            ColorModeNotifier.set(value, Themes.flutterColorThemes[value]!);
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
          colorListTile(title: toBeginningOfSentenceCase(name)!, value: name));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Theme Mode, aka light or dark mode
          ...[
            Text(
              AppLocalizations.of(context)!.theme,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            RadioListTile(
              title: Text(AppLocalizations.of(context)!.lightMode),
              value: "light",
              groupValue: _selectedTheme,
              onChanged: (value) {
                if (_selectedTheme == "amoled") {
                  String parseSelectedTheme = value.toString();
                  ThemeModeNotifier.set(parseSelectedTheme);
                } else {
                  setState(() {
                    _selectedTheme = value.toString();
                    ThemeModeNotifier.set(_selectedTheme);
                  });
                }
              },
            ),
            RadioListTile(
              title: Text(AppLocalizations.of(context)!.darkMode),
              value: "dark",
              groupValue: _selectedTheme,
              onChanged: (value) {
                if (_selectedTheme == "amoled") {
                  String parseSelectedTheme = value.toString();
                  ThemeModeNotifier.set(parseSelectedTheme);
                } else {
                  setState(() {
                    _selectedTheme = value.toString();
                    ThemeModeNotifier.set(_selectedTheme);
                  });
                }
              },
            ),
            RadioListTile(
              title: Text(AppLocalizations.of(context)!.amoledMode),
              value: "amoled",
              groupValue: _selectedTheme,
              onChanged: (value) {
                String parseSelectedTheme = value.toString();
                ThemeModeNotifier.set(parseSelectedTheme);
              },
            ),
            RadioListTile(
              title: Text(AppLocalizations.of(context)!.systemMode),
              value: "system",
              groupValue: _selectedTheme,
              onChanged: (value) {
                if (_selectedTheme == "amoled") {
                  String parseSelectedTheme = value.toString();
                  ThemeModeNotifier.set(parseSelectedTheme);
                } else {
                  setState(() {
                    _selectedTheme = value.toString();
                    ThemeModeNotifier.set(_selectedTheme);
                  });
                }
              },
            ),
          ],
          const Divider(),
          // Color mode, aka the primary color accent of the app
          ...[
            Text(
              AppLocalizations.of(context)!.accentColor,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            colorListTile(
              title: AppLocalizations.of(context)!.standard,
              value: "standard",
              primaryColor: Theme.of(context).brightness == Brightness.dark
                  ? Themes.standardTheme.darkTheme!.colorScheme.primary
                  : Themes.standardTheme.lightTheme!.colorScheme.primary,
            ),
            RadioListTile(
              title: Text(AppLocalizations.of(context)!.dynamicColor),
              subtitle: const Text('Material You'),
              secondary: Themes.dynamicTheme.lightTheme == null
                  ? null
                  : Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.onSurface,
                              width: 2),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Themes.dynamicTheme.darkTheme!.colorScheme
                                        .primary
                                    : Themes.dynamicTheme.lightTheme!
                                        .colorScheme.primary,
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
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Themes.dynamicTheme.darkTheme!.colorScheme
                                        .secondary
                                    : Themes.dynamicTheme.lightTheme!
                                        .colorScheme.secondary,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
              value: "dynamic",
              groupValue: _selectedColor,
              onChanged: Themes.dynamicTheme.lightTheme == null
                  ? null
                  : (value) {
                      setState(() {
                        _selectedColor = value.toString();
                        ColorModeNotifier.set("dynamic", Themes.dynamicTheme);
                      });
                    },
            ),
            colorListTile(
              title: AppLocalizations.of(context)!.schoolColor,
              subtitle:
                  AppLocalizations.of(context)!.schoolColorOriginExplanation,
              value: "school",
              primaryColor: Theme.of(context).brightness == Brightness.dark
                  ? Themes.schoolTheme.darkTheme!.colorScheme.primary
                  : Themes.schoolTheme.lightTheme!.colorScheme.primary,
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

Future<bool?> showRestartConfirmationBool(bool isFromAmoled, bool isToAmoled) {
  final completer = Completer<bool?>();

  return showDialog<bool>(
    context: navigatorKey.currentState!.overlay!.context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.restart_question),
      content: Text(AppLocalizations.of(context)!.restartNeededForThemeSwitch),
      actions: [
        TextButton(
          onPressed: () {
            completer.complete(false);
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () {
            completer.complete(true);
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.restart),
        ),
      ],
    ),
  ).then((value) => completer.future);
}

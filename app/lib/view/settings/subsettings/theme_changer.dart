import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/core/database/account_database/account_db.dart';
import 'package:sph_plan/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  late String _selectedTheme = "system"; // Default theme
  late String _selectedColor = "standard"; // Default color
  late bool _isAmoled = false;

  @override
  void initState() {
    loadSettingsVars();
    super.initState();
  }
  void loadSettingsVars() async {
    _selectedTheme = (await accountDatabase.kv.get('theme'))!;
    _selectedColor = (await accountDatabase.kv.get('color'))!;
    _isAmoled = bool.parse((await accountDatabase.kv.get('isAmoled'))!);
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
                    ? Themes.flutterColorThemes[value]?.darkTheme?.colorScheme
                        .primary
                    : Themes.flutterColorThemes[value]?.lightTheme?.colorScheme
                        .primary),
          ),
        ),
      ),
      value: value,
      groupValue: _selectedColor,
      onChanged: (value) {
        setState(() {
          _selectedColor = value.toString();
          accountDatabase.kv.set('color', _selectedColor);
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
              title: Text(AppLocalizations.of(context)!.systemMode),
              value: "system",
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value.toString();
                  accountDatabase.kv.set('theme', _selectedTheme);
                });
              },
            ),
            RadioListTile(
              title: Text(AppLocalizations.of(context)!.lightMode),
              value: "light",
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value.toString();
                  accountDatabase.kv.set('theme', _selectedTheme);
                });
              },
            ),
            RadioListTile(
              title: Text(AppLocalizations.of(context)!.darkMode),
              value: "dark",
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value.toString();
                  accountDatabase.kv.set('theme', _selectedTheme);
                });
              },
            ),
            Visibility(
              visible: Theme.of(context).brightness == Brightness.dark,
                child: Column(
                  children: [
                    const Divider(
                      indent: 25,
                      endIndent: 25,
                      height: 15,
                    ),
                    CheckboxListTile(
                        title: Text(AppLocalizations.of(context)!.amoledMode),
                        value: _isAmoled,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (value) {
                          setState(() {
                            _isAmoled = value!;
                            accountDatabase.kv.set('isAmoled', _isAmoled.toString());
                          });
                        }
                    ),
                  ],
                )
            )
          ],
          const SizedBox(height: 10.0),
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

                        accountDatabase.kv.set('color', _selectedColor);
                      });
                    },
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

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sph_plan/core/database/account_database/account_db.dart';
import 'package:sph_plan/themes.dart';

class AppearanceSettings extends StatefulWidget {
  const AppearanceSettings({super.key});

  @override
  State<AppearanceSettings> createState() => _AppearanceSettingsState();
}

class _AppearanceSettingsState extends State<AppearanceSettings> {
  RadioListTile colorListTile(
      {required String title,
      required String value,
      Color? primaryColor,
      String? subtitle,
      required void Function(String data) onSelect,
      bool selected = false}) {
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
      value: '0',
      groupValue: selected ? '0' : '1',
      onChanged: (value) {
        onSelect(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appearance),
      ),
      body: StreamBuilder(
        stream: accountDatabase.kv.subscribeMultiple(
            ['color', 'theme', 'isAmoled', 'enableSubstitutionsInfo']),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  AppLocalizations.of(context)!.theme,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              RadioListTile(
                title: Text(AppLocalizations.of(context)!.systemMode),
                value: "system",
                groupValue: snapshot.data!['theme'],
                onChanged: (value) {
                  accountDatabase.kv.set('theme', value!);
                },
              ),
              RadioListTile(
                title: Text(AppLocalizations.of(context)!.lightMode),
                value: "light",
                groupValue: snapshot.data!['theme'],
                onChanged: (value) {
                  accountDatabase.kv.set('theme', value!);
                },
              ),
              RadioListTile(
                title: Text(AppLocalizations.of(context)!.darkMode),
                value: "dark",
                groupValue: snapshot.data!['theme'],
                onChanged: (value) {
                  accountDatabase.kv.set('theme', value!);
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
                          value: snapshot.data!['isAmoled'] == 'true',
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (value) {
                            accountDatabase.kv
                                .set('isAmoled', value.toString());
                          }),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  AppLocalizations.of(context)!.accentColor,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              colorListTile(
                title: AppLocalizations.of(context)!.standard,
                value: "standard",
                primaryColor: Theme.of(context).brightness == Brightness.dark
                    ? Themes.standardTheme.darkTheme!.colorScheme.primary
                    : Themes.standardTheme.lightTheme!.colorScheme.primary,
                onSelect: (_) => accountDatabase.kv.set('color', 'standard'),
                selected: snapshot.data!['color'] == 'standard',
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
                                      ? Themes.dynamicTheme.darkTheme!
                                          .colorScheme.primary
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
                                      ? Themes.dynamicTheme.darkTheme!
                                          .colorScheme.secondary
                                      : Themes.dynamicTheme.lightTheme!
                                          .colorScheme.secondary,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                value: "dynamic",
                groupValue: snapshot.data!['color'],
                onChanged: Themes.dynamicTheme.lightTheme == null
                    ? null
                    : (value) {
                        setState(() {
                          accountDatabase.kv.set('color', 'dynamic');
                        });
                      },
              ),
              const Divider(
                indent: 25,
                endIndent: 25,
                height: 15,
              ),
              ...Themes.flutterColorThemes.keys.map((key) => colorListTile(
                    title: firstLetterUpperCase(key),
                    value: key,
                    selected: snapshot.data!['color'] == key,
                    onSelect: (_) => accountDatabase.kv.set('color', key),
                  )),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  AppLocalizations.of(context)!.substitutions,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              CheckboxListTile(
                  title: Text(
                      AppLocalizations.of(context)!.enableSubstitutionsInfo),
                  value: snapshot.data!['enableSubstitutionsInfo'] == 'true',
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    accountDatabase.kv
                        .set('enableSubstitutionsInfo', value.toString());
                  }),
            ],
          );
        },
      ),
    );
  }
}

String firstLetterUpperCase(String text) {
  return text[0].toUpperCase() + text.substring(1);
}

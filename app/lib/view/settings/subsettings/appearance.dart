import 'package:flutter/material.dart';
import 'package:sph_plan/core/database/account_database/account_db.dart';
import 'package:sph_plan/themes.dart';
import 'package:sph_plan/utils/radio_pills.dart';
import 'package:sph_plan/utils/switch_tile.dart';
import 'package:sph_plan/view/settings/settings_page_builder.dart';

class AppearanceSettings extends SettingsColours {
  const AppearanceSettings({super.key});

  @override
  State<AppearanceSettings> createState() => _AppearanceSettingsState();
}

class _AppearanceSettingsState
    extends SettingsColoursState<AppearanceSettings> {
  ThemeData? dynamicTheme = Themes.dynamicTheme.lightTheme;

  @override
  void didChangeDependencies() {
    setState(() {
      dynamicTheme = Theme.of(context).brightness == Brightness.dark
          ? Themes.dynamicTheme.darkTheme
          : Themes.dynamicTheme.lightTheme;
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsPageWithStreamBuilder(
        backgroundColor: backgroundColor,
        title: Text("Appearance"),
        subscription: accountDatabase.kv
            .subscribeMultiple(['color', 'theme', 'isAmoled']),
        builder: (context, snapshot) {
          return [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Theme",
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: RadioPillGroup<String>(
                  groupValue: snapshot.data!['theme'],
                  onChanged: (value) {
                    accountDatabase.kv.set('theme', value);
                  },
                  color: foregroundColor,
                  pills: [
                    RadioPillGroupItem.vertical(
                        title: Text("System"),
                        leading: Icon(Icons.phone_android_rounded),
                        value: "system"),
                    RadioPillGroupItem.vertical(
                        title: Text("Light"),
                        leading: Icon(Icons.light_mode_rounded),
                        value: "light"),
                    RadioPillGroupItem.vertical(
                        title: Text("Dark"),
                        leading: Icon(Icons.dark_mode_rounded),
                        value: "dark"),
                  ],
                )),
            Visibility(
              visible: Theme.of(context).brightness == Brightness.dark,
              child: Column(
                children: [
                  SizedBox(
                    height: 16.0,
                  ),
                  MinimalSwitchTile(
                      title: Text(
                        "Black Mode",
                      ),
                      leading: Icon(Icons.contrast_rounded),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      useInkWell: true,
                      value: snapshot.data!['isAmoled'] == 'true',
                      onChanged: (value) {
                        accountDatabase.kv.set('isAmoled', value.toString());
                      }),
                ],
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Accent colour",
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: RadioPillGroup<String>.large(
                  groupValue: snapshot.data!['color'],
                  onChanged: (value) {
                    accountDatabase.kv.set('color', value);
                  },
                  color: foregroundColor,
                  pills: [
                    RadioPillGroupItem.horizontal(
                        title: Text("Standard"),
                        value: "standard",
                        trailing: TrailingCircle(
                          color: Themes.standardTheme.lightTheme!.colorScheme
                              .primaryFixedDim,
                          selectedBackgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          selectedColor: Theme.of(context).colorScheme.primary,
                          selected: snapshot.data!['color'] == "standard",
                        )),
                    if (dynamicTheme != null)
                      RadioPillGroupItem.horizontal(
                          title: Text("Material You"),
                          value: "dynamic",
                          trailing: TrailingCircle.custom(
                            selectedBackgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            selectedColor:
                                Theme.of(context).colorScheme.primary,
                            selected: snapshot.data!['color'] == "dynamic",
                            customCircle: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(100)),
                                      color: dynamicTheme!.colorScheme.primary,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(100)),
                                          color: dynamicTheme!
                                              .colorScheme.inversePrimary,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomRight:
                                                  Radius.circular(100)),
                                          color: dynamicTheme!
                                              .colorScheme.secondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                              ],
                            ),
                          )),
                  ],
                  customPillBuilder:
                      (String? groupValue, void Function(String)? onChanged) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 2.0,
                        ),
                        RadioTrailingCircleGroup<String>(
                          groupValue: groupValue,
                          onChanged: onChanged,
                          border: RadioBorder.bottom,
                          color: foregroundColor,
                          colors: List<ColorPair<String>>.generate(
                              Themes.flutterColorThemes.keys.length, (index) {
                            final key =
                                Themes.flutterColorThemes.keys.elementAt(index);

                            return ColorPair<String>(
                              color: Themes.flutterColorThemes[key]!.lightTheme!
                                  .colorScheme.primaryFixedDim,
                              value: key,
                            );
                          }),
                        ),
                      ],
                    );
                  },
                )),
          ];
        });
  }
}

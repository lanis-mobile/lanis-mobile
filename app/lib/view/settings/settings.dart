import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:sph_plan/view/settings/settings_page_builder.dart';
import 'package:sph_plan/view/settings/subsettings/about.dart';
import 'package:sph_plan/view/settings/subsettings/cache.dart';
import 'package:sph_plan/view/settings/subsettings/notifications.dart';
import 'package:sph_plan/view/settings/subsettings/appearance.dart';
import 'package:sph_plan/view/settings/subsettings/userdata.dart';

import '../../core/database/account_database/account_db.dart';
import '../../core/sph/sph.dart';
import '../../utils/press_tile.dart';

class SettingsGroup {
  final List<SettingsTile> tiles;

  const SettingsGroup({required this.tiles});
}

class SettingsTile {
  final String title;
  final Future<String> Function(BuildContext context) subtitle;
  final IconData icon;
  final Future<void> Function(BuildContext context) screen;
  final Future<bool> Function() show;

  static Future<bool> alwaysShow() async {
    return true;
  }

  const SettingsTile(
      {required this.title,
      required this.subtitle,
      required this.icon,
      required this.screen,
      this.show = alwaysShow});
}

class SettingsScreen extends SettingsColours {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends SettingsColoursState<SettingsScreen> {
  final List<SettingsGroup> settingsTiles = [
    SettingsGroup(tiles: [
      SettingsTile(
          title: "Appearance",
          subtitle: (context) async {
            return "Dark theme, colours";
          },
          icon: Icons.palette_rounded,
          screen: (context) => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppearanceSettings()),
              )),
      SettingsTile(
        title: "Language",
        subtitle: (context) async {
          String code = Localizations.localeOf(context).languageCode;

          if (code.contains("de")) {
            return "Deutsch";
          } else if (code.contains("en")) {
            return "English";
          } else {
            return "Unknown";
          }
        },
        icon: Icons.language_rounded,
        screen: (context) =>
            AppSettings.openAppSettings(type: AppSettingsType.appLocale),
        show: () async {
          if (!Platform.isAndroid) {
            return false;
          }

          DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
          final androidInfo = await deviceInfo.androidInfo;
          return androidInfo.version.sdkInt >= 33;
        },
      ),
      SettingsTile(
          title: "Notifications",
          subtitle: (context) async {
            return "Interval, applets";
          },
          icon: Icons.notifications_rounded,
          screen: (context) async {
            int accountCount = await accountDatabase
                .select(accountDatabase.accountsTable)
                .get()
                .then((value) => value.length);

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      NotificationSettings(accountCount: accountCount)),
            );
          }),
      SettingsTile(
          title: "Clear cache",
          subtitle: (context) async {
            Map<String, int> cacheStats = {'fileNum': 0, 'size': 0};

            final dir = await sph!.storage.getDocumentCacheDirectory();

            cacheStats = CacheSettings.dirStatSync(dir.path);

            return "${cacheStats['fileNum']} ${cacheStats['fileNum'] == 1 ? "file" : "files"} (${cacheStats['size']! ~/ 1024} KB)";
          },
          icon: Icons.storage_rounded,
          screen: (context) => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CacheSettings()),
              )),
    ]),
    SettingsGroup(tiles: [
      SettingsTile(
        title: "User data",
        subtitle: (context) async {
          return "Age, name, class";
        },
        icon: Icons.account_circle_rounded,
        screen: (context) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserDataSettings()),
        ),
      ),
    ]),
    SettingsGroup(tiles: [
      SettingsTile(
        title: "About Lanis-Mobile",
        subtitle: (context) async {
          return "Contributors, links, licenses";
        },
        icon: Icons.school_rounded,
        screen: (context) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutSettings()),
        ),
      )
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      backgroundColor: backgroundColor,
      title: Text(
        "Settings",
      ),
      children: List.generate(settingsTiles.length, (groupIndex) {
        return Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
          child: Column(
            spacing: 2.0,
              children: List.generate(settingsTiles[groupIndex].tiles.length,
                  (tileIndex) {
            return SettingsTileWidget(
              tile: settingsTiles[groupIndex].tiles[tileIndex],
              index: tileIndex,
              length: settingsTiles[groupIndex].tiles.length,
              foregroundColor: foregroundColor,
            );
          })),
        );
      }),
    );
  }
}

class SettingsTileWidget extends StatefulWidget {
  final SettingsTile tile;
  final int index;
  final int length;
  final Color foregroundColor;
  const SettingsTileWidget({super.key, required this.tile, required this.foregroundColor, required this.index, required this.length});

  static BorderRadius getRadius(int index, int length) {
    if (index == 0 && length > 1) {
      return BorderRadius.only(
          topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0));
    } else if (index == 0) {
      return BorderRadius.circular(12.0);
    } else if (index == length - 1) {
      return BorderRadius.only(
          bottomLeft: Radius.circular(12.0),
          bottomRight: Radius.circular(12.0));
    } else {
      return BorderRadius.zero;
    }
  }

  @override
  State<SettingsTileWidget> createState() => _SettingsTileWidgetState();
}

class _SettingsTileWidgetState extends State<SettingsTileWidget> {
  String subtitle = "";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        widget.tile.show(),
        widget.tile.subtitle(context),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return PressTile(
            title: widget.tile.title,
            subtitle: subtitle,
            icon: widget.tile.icon,
            onPressed: () async {
              await widget.tile.screen(context);

              setState(() {

              });
            },
            foregroundColor: widget.foregroundColor,
            borderRadius: SettingsTileWidget.getRadius(
                widget.index, widget.length),
          );
        }

        subtitle = snapshot.data![1] as String;

        return Visibility(
          visible: snapshot.data![0] as bool,
            child: PressTile(
              title: widget.tile.title,
              subtitle: subtitle,
              icon: widget.tile.icon,
              onPressed: () async {
                await widget.tile.screen(context);

                setState(() {

                });
              },
              foregroundColor: widget.foregroundColor,
              borderRadius: SettingsTileWidget.getRadius(
                  widget.index, widget.length),
            )
        );
      },
    );
  }
}


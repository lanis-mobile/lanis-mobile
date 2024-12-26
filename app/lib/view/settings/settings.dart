import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sph_plan/utils/large_appbar.dart';

import '../../core/sph/sph.dart';

class SettingsGroup {
  final List<SettingsTile> tiles;

  const SettingsGroup({required this.tiles});
}

class SettingsTile {
  final String title;
  final Future<String> Function(BuildContext context) subtitle;
  final IconData icon;
  final Future<bool> Function() show;

  static Future<bool> alwaysShow() async {
    return true;
  }

  const SettingsTile(
      {required this.title,
      required this.subtitle,
      required this.icon,
      this.show = alwaysShow});
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<SettingsGroup> settingsTiles = [
    SettingsGroup(tiles: [
      SettingsTile(
          title: "Appearance",
          subtitle: (context) async {
            return "Dark theme, colours";
          },
          icon: Icons.palette_rounded),
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
        show: () async {
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
          icon: Icons.notifications_rounded),
      SettingsTile(
          title: "Clear cache",
          subtitle: (context) async {
            Map<String, int> cacheStats = {'fileNum': 0, 'size': 0};

            final dir = await sph!.storage.getDocumentCacheDirectory();

            cacheStats = dirStatSync(dir.path);

            return "${cacheStats['fileNum']} ${cacheStats['fileNum'] == 1 ? "file" : "files"} (${cacheStats['size']! ~/ 1024} KB)";
          },
          icon: Icons.storage_rounded),
    ]),
    SettingsGroup(tiles: [
      SettingsTile(
          title: "User data",
          subtitle: (context) async {
            return "Age, name, class";
          },
          icon: Icons.account_circle_rounded)
    ]),
    SettingsGroup(tiles: [
      SettingsTile(
          title: "About Lanis-Mobile",
          subtitle: (context) async {
            return "Contributors, links, licenses";
          },
          icon: Icons.school_rounded)
    ]),
  ];

  static Map<String, int> dirStatSync(String dirPath) {
    int fileNum = 0;
    int totalSize = 0;
    var dir = Directory(dirPath);

    if (dir.existsSync()) {
      dir
          .listSync(recursive: true, followLinks: false)
          .forEach((FileSystemEntity entity) {
        if (entity is File) {
          fileNum++;
          totalSize += entity.lengthSync();
        }
      });
    }
    return {'fileNum': fileNum, 'size': totalSize};
  }

  BorderRadius getRadius(int index, int length) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      appBar: LargeAppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      ),
      body: CustomScrollView(
        slivers: [
          ...List.generate(settingsTiles.length, (groupIndex) {
            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 10.0),
                child: Column(
                    children: List.generate(
                        settingsTiles[groupIndex].tiles.length, (tileIndex) {
                  return FutureBuilder(
                    future: Future.wait([
                      settingsTiles[groupIndex].tiles[tileIndex].show(),
                      settingsTiles[groupIndex].tiles[tileIndex].subtitle(context),
                    ]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return SizedBox.shrink();
                      }

                      return Visibility(
                        visible: snapshot.data![0] as bool,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: Material(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerLow,
                            borderRadius: getRadius(tileIndex,
                                settingsTiles[groupIndex].tiles.length),
                            child: InkWell(
                              onTap: () {},
                              borderRadius: getRadius(tileIndex,
                                  settingsTiles[groupIndex].tiles.length),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 12.0),
                                child: Row(
                                  children: [
                                    Icon(settingsTiles[groupIndex]
                                        .tiles[tileIndex]
                                        .icon),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          settingsTiles[groupIndex]
                                              .tiles[tileIndex]
                                              .title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                              ),
                                        ),
                                        Text(
                                          snapshot.data![1] as String,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                })),
              ),
            );
          })
        ],
      ),
    );
  }
}

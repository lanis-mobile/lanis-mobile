import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:lanis/applets/calendar/definition.dart';
import 'package:lanis/applets/timetable/definition.dart';
import 'package:lanis/applets/timetable/student/student_timetable_settings.dart';
import 'package:lanis/generated/l10n.dart';
import 'package:lanis/utils/large_appbar.dart';
import 'package:lanis/utils/responsive.dart';
import 'package:lanis/view/settings/settings_page_builder.dart';
import 'package:lanis/view/settings/subsettings/about.dart';
import 'package:lanis/view/settings/subsettings/appearance.dart';
import 'package:lanis/view/settings/subsettings/cache.dart';
import 'package:lanis/view/settings/subsettings/notifications.dart';
import 'package:lanis/view/settings/subsettings/quick_actions.dart';
import 'package:lanis/view/settings/subsettings/userdata.dart';

import '../../applets/calendar/calendar_export.dart';
import '../../core/database/account_database/account_db.dart';
import '../../core/sph/sph.dart';
import '../../utils/press_tile.dart';
import '../../utils/whats_new.dart';
import '../../widgets/dynamic_app_bar.dart';

class SettingsGroup {
  final List<SettingsTile> tiles;

  const SettingsGroup({required this.tiles});
}

class SettingsTile {
  final String Function(BuildContext context) title;
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
          title: (context) => AppLocalizations.of(context).appearance,
          subtitle: (context) async {
            return AppLocalizations.of(context).darkModeColoursList;
          },
          icon: Icons.palette_rounded,
          screen: (context) => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppearanceSettings()),
              )),
      SettingsTile(
        title: (context) => AppLocalizations.of(context).language,
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
        title: (context) => AppLocalizations.of(context).notifications,
        subtitle: (context) async {
          return AppLocalizations.of(context).intervalAppletsList;
        },
        icon: Icons.notifications_rounded,
        screen: (context) async {
          int accountCount = await accountDatabase
              .select(accountDatabase.accountsTable)
              .get()
              .then((value) => value.length);

          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      NotificationSettings(accountCount: accountCount)),
            );
          }
        },
      ),
      SettingsTile(
          title: (context) => AppLocalizations.of(context).clearCache,
          subtitle: (context) async {
            Map<String, int> cacheStats = {'fileNum': 0, 'size': 0};

            final dir = await sph!.storage.getDocumentCacheDirectory();

            cacheStats = CacheSettings.dirStatSync(dir.path);

            return "${cacheStats['fileNum']} ${cacheStats['fileNum'] == 1 ? (context.mounted ? AppLocalizations.of(context).file : 'Datei') : (context.mounted ? AppLocalizations.of(context).files : 'Dateien')} (${cacheStats['size']! ~/ 1024} KB)";
          },
          icon: Icons.storage_rounded,
          screen: (context) => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CacheSettings()),
              )),
      SettingsTile(
        title: (context) => AppLocalizations.of(context).quickActions,
        subtitle: (context) async =>
            "${AppLocalizations.of(context).applets}, ${AppLocalizations.of(context).external}",
        icon: Icons.extension,
        screen: (context) => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuickActions(
                    showBackButton: true,
                  )),
        ),
      )
    ]),
    if (sph!.session.doesSupportFeature(calendarDefinition) ||
        sph!.session.doesSupportFeature(timeTableDefinition))
      SettingsGroup(tiles: [
        if (sph!.session.doesSupportFeature(calendarDefinition))
          SettingsTile(
            title: (context) => AppLocalizations.of(context).calendarExport,
            subtitle: (context) async => 'PDF, iCal, ICS, CSV',
            icon: Icons.download_rounded,
            screen: (context) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CalendarExport(),
              ),
            ),
          ),
        if (sph!.session.doesSupportFeature(timeTableDefinition))
          SettingsTile(
            title: (context) => AppLocalizations.of(context).customizeTimetable,
            subtitle: (context) async =>
                AppLocalizations.of(context).customizeTimetableDescription,
            icon: Icons.timelapse,
            screen: (context) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const StudentTimetableSettings()),
            ),
          ),
      ]),
    SettingsGroup(tiles: [
      SettingsTile(
        title: (context) => AppLocalizations.of(context).userData,
        subtitle: (context) async {
          return AppLocalizations.of(context).ageNameClassList;
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
        title: (context) => AppLocalizations.of(context).about,
        subtitle: (context) async {
          return AppLocalizations.of(context).contributorsLinksLicensesList;
        },
        icon: Icons.school_rounded,
        screen: (context) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutSettings()),
        ),
      ),
      SettingsTile(
        icon: Icons.question_mark,
        show: () async => true,
        title: (context) => AppLocalizations.of(context).inThisUpdate,
        subtitle: (context) async =>
            AppLocalizations.of(context).showReleaseNotesForThisVersion,
        screen: (context) async => showLocalUpdateInfo(context),
      )
    ]),
  ];

  SettingsTile? selectedTile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppBarController.instance.setOverrideColor((context) => backgroundColor);
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppBarController.instance.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTabletApplet(context);
    final double availableHeight = MediaQuery.of(context).size.height -
        kToolbarHeight -
        MediaQuery.of(context).padding.top;

    if (mounted &&
        Responsive.isTabletApplet(context) &&
        settingsTiles.isNotEmpty &&
        settingsTiles[0].tiles.isNotEmpty &&
        selectedTile == null) {
      selectedTile = settingsTiles[0].tiles[0];
    }

    Widget settingsList = SizedBox(
      height: availableHeight,
      child: ListView.builder(
        itemCount: settingsTiles.length,
        itemBuilder: (context, groupIndex) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(settingsTiles[groupIndex].tiles.length,
                  (tileIndex) {
                final tile = settingsTiles[groupIndex].tiles[tileIndex];
                return SettingsTileWidget(
                  tile: tile,
                  index: tileIndex,
                  length: settingsTiles[groupIndex].tiles.length,
                  foregroundColor: foregroundColor,
                  selected: isTablet && selectedTile == tile,
                  onSelect: isTablet
                      ? (tile) {
                          if (tile.title(context) ==
                              AppLocalizations.of(context).language) {
                            return tile.screen(context);
                          }
                          setState(() => selectedTile = tile);
                        }
                      : null,
                );
              }),
            ),
          );
        },
      ),
    );

    if (!isTablet) {
      return SettingsPage(
        backgroundColor: backgroundColor,
        title: Text(AppLocalizations.of(context).settings),
        showAppBar: false,
        children: [settingsList],
      );
    }

    // Tablet layout
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Row(
        children: [
          SizedBox(
            width: 300, // Fixed width for settings list
            child: settingsList,
          ),
          const VerticalDivider(width: 1),
          Expanded(
            // At this point selectedTile should/can never be null
            child: _buildSettingDetail(selectedTile!),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingDetail(SettingsTile tile) {
    return Builder(
      builder: (context) {
        final isTablet = Responsive.isTabletApplet(context);
        if (tile.title(context) == AppLocalizations.of(context).appearance) {
          return AppearanceSettings(showBackButton: !isTablet);
        } else if (tile.title(context) ==
            AppLocalizations.of(context).notifications) {
          return NotificationSettings(
              accountCount: 1, showBackButton: !isTablet);
        } else if (tile.title(context) ==
            AppLocalizations.of(context).clearCache) {
          return CacheSettings(showBackButton: !isTablet);
        } else if (tile.title(context) ==
            AppLocalizations.of(context).userData) {
          return UserDataSettings(showBackButton: !isTablet);
        } else if (tile.title(context) == AppLocalizations.of(context).about) {
          return AboutSettings(showBackButton: !isTablet);
        } else if (tile.title(context) ==
            AppLocalizations.of(context).calendarExport) {
          return CalendarExport(showBackButton: !isTablet);
        } else if (tile.title(context) ==
            AppLocalizations.of(context).customizeTimetable) {
          return StudentTimetableSettings(showBack: !isTablet);
        } else if (tile.title(context) ==
            AppLocalizations.of(context).quickActions) {
          return QuickActions(showBackButton: !isTablet);
        } else if (tile.title(context) ==
            AppLocalizations.of(context).inThisUpdate) {
          return FutureBuilder(
              future: showLocalUpdateInfo(context, dialog: false),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Scaffold(
                    appBar: LargeAppBar(
                        showBackButton: false,
                        backgroundColor: backgroundColor,
                        title: Text(AppLocalizations.of(context).inThisUpdate)),
                    body: snapshot.data as Widget,
                  );
                }
                return const Center(child: CircularProgressIndicator());
              });
        }
        return Center(child: Text(AppLocalizations.of(context).noResults));
      },
    );
  }
}

class SettingsTileWidget extends StatefulWidget {
  final SettingsTile tile;
  final int index;
  final int length;
  final Color foregroundColor;
  final bool disableSetState;
  final bool selected;
  final Function(SettingsTile)? onSelect;
  final bool preventNavigation;

  const SettingsTileWidget(
      {super.key,
      required this.tile,
      required this.foregroundColor,
      required this.index,
      required this.length,
      this.disableSetState = false,
      this.selected = false,
      this.onSelect,
      this.preventNavigation = false});

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
          return _buildTile(subtitle);
        }

        subtitle = snapshot.data![1] as String;

        return Visibility(
          visible: snapshot.data![0] as bool,
          child: _buildTile(subtitle),
        );
      },
    );
  }

  Widget _buildTile(String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: PressTile(
        title: widget.tile.title(context),
        subtitle: subtitle,
        icon: widget.tile.icon,
        selected: widget.selected,
        onPressed: () {
          if (widget.onSelect != null) {
            widget.onSelect!(widget.tile);
          } else {
            widget.tile.screen(context);
          }
        },
        foregroundColor: widget.foregroundColor,
        borderRadius: SettingsTileWidget.getRadius(widget.index, widget.length),
      ),
    );
  }
}

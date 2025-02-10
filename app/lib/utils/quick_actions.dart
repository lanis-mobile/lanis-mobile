import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:sph_plan/applets/definitions.dart';
import 'package:sph_plan/core/database/account_database/account_db.dart';
import 'package:sph_plan/core/sph/sph.dart';
import 'package:sph_plan/home_page.dart';
import 'package:sph_plan/utils/logger.dart';

late final QuickActions quickActions;
bool _quickActionsSet = false;

class QuickActionsStartUp {

  static final Completer<void> _initializationCompleter = Completer<void>();

  QuickActionsStartUp() {
    quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      for (final applet in AppDefinitions.applets) {
        if (applet.appletPhpUrl == shortcutType &&
            sph!.session.doesSupportFeature(applet)
        ) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            int appletIndex = AppDefinitions.getIndexByPhpIdentifier(
                applet.appletPhpUrl);
            logger.i('Opening applet: ${applet.appletPhpUrl}');
            selectedDestinationDrawer = appletIndex;
          });
          break;

        }
      }
      for (final applet in AppDefinitions.external) {
        if (applet.id == shortcutType) {

          // Wait until the flutter app is fully initialized
          WidgetsBinding.instance.addPostFrameCallback((_) {
            applet.action?.call();
          });
        }
      }
    });
    _initializationCompleter.complete();
  }

  static Future<void> waitForInitialization() async {
    await _initializationCompleter.future;
  }

  static void setNames(BuildContext context) async {
    if (_quickActionsSet) return;
    await waitForInitialization();
    String? enabledShortcuts = await accountDatabase.kv.get('quick-actions');
    if (!context.mounted) return;
    List enabledShortcutsList = enabledShortcuts?.split(',') ?? [];

    List<ShortcutItem> shortcuts = [];
    for (final applet in AppDefinitions.applets) {
      if (enabledShortcutsList.contains(applet.appletPhpUrl)) {
        shortcuts.add(ShortcutItem(
          type: applet.appletPhpUrl,
          localizedTitle: applet.label(context),
          icon: '@mipmap/ic_launcher_monochrome',
        ));
      }
    }
    for (final applet in AppDefinitions.external) {
      if (enabledShortcutsList.contains(applet.id)) {
        shortcuts.add(ShortcutItem(
          type: applet.id,
          localizedTitle: applet.label(context),
          icon: '@mipmap/ic_launcher_monochrome',
        ));
      }
    }

    await quickActions.setShortcutItems(shortcuts);
    _quickActionsSet = true;
  }
}

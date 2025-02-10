import 'package:flutter/cupertino.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:sph_plan/applets/definitions.dart';
import 'package:sph_plan/core/database/account_database/account_db.dart';
import 'package:sph_plan/utils/logger.dart';

late final QuickActions quickActions;
bool _quickActionsSet = false;

class QuickActionsStartUp {

  QuickActionsStartUp() {
    quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      for (final applet in AppDefinitions.applets) {
        if (applet.appletPhpUrl == shortcutType) {
          // TODO: Set applet
          break;
        }
      }
    });
  }

  static void setNames(BuildContext context) async {
    if (_quickActionsSet) return;
    String? enabledShortcuts = await accountDatabase.kv.get('enabledShortcuts');
    enabledShortcuts = 'vertretungsplan.php';
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

    await quickActions.setShortcutItems(shortcuts);
    _quickActionsSet = true;
  }
}

import 'package:flutter/material.dart';
import 'package:lanis/applets/definitions.dart';

import '../../models/account_types.dart';
import '../../utils/custom_icons.dart';
import 'moodle.dart';

final moodleDefinition = AppletDefinition(
  appletPhpIdentifier: 'schulmoodle.php',
  addDivider: true,
  useBottomNavigation: false,
  icon: (context) => Icon(BrowserIcons.moodle),
  selectedIcon: (context) => Icon(BrowserIcons.moodle),
  settingsDefaults: {},
  label: (context) => 'Moodle',
  supportedAccountTypes: [AccountType.student, AccountType.parent, AccountType.teacher],
  allowOffline: false,
  refreshInterval: Duration(days: 356),
  bodyBuilder: (context, accountType, openDrawerCb) {
    return MoodleWebView();
  },
);

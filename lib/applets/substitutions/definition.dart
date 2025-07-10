import 'package:flutter/material.dart';
import 'package:lanis/generated/l10n.dart';
import 'package:lanis/applets/definitions.dart';
import 'package:lanis/applets/substitutions/substitutions_view.dart';

import '../../models/account_types.dart';
import 'background.dart';

final substitutionDefinition = AppletDefinition(
  appletPhpIdentifier: 'vertretungsplan.php',
  icon: (context) => Icon(Icons.people),
  selectedIcon: (context) => Icon(Icons.people_outline),
  useBottomNavigation: true,
  addDivider: false,
  allowOffline: true,
  label: (context) => AppLocalizations.of(context).substitutions,
  supportedAccountTypes: [AccountType.student, AccountType.teacher, AccountType.parent],
  refreshInterval: Duration(minutes: 10),
  settingsDefaults: {},
  notificationTask: substitutionsBackgroundTask,
  bodyBuilder: (context, accountType, openDrawerCb) {
    return SubstitutionsView();
  },
);

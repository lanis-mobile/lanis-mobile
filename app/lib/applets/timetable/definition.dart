import 'package:flutter/material.dart';
import 'package:sph_plan/applets/definitions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../shared/account_types.dart';

final timeTableDefinition = AppletDefinition(
  appletPhpUrl: 'stundenplan.php',
  icon: Icon(Icons.timelapse),
  selectedIcon: Icon(Icons.timelapse_outlined),
  appletType: AppletType.withBottomNavigation,
  addDivider: false,
  label: (context) => AppLocalizations.of(context)!.substitutions,
  supportedAccountTypes: [AccountType.student],
  refreshInterval: Duration(hours: 1),
  settings: {},
  bodyBuilder: (context, accountType) {
    return Container();
  },
);

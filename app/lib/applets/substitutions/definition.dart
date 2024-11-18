import 'package:flutter/material.dart';
import 'package:sph_plan/applets/definitions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../shared/account_types.dart';

final definition = AppletDefinition(
  appletPhpUrl: 'vertretungsplan.php',
  icon: Icon(Icons.swap_horiz),
  selectedIcon: Icon(Icons.swap_horiz),
  appletType: AppletType.withBottomNavigation,
  addDivider: true,
  label: (context) => AppLocalizations.of(context)!.substitutions,
  supportedAccountTypes: [AccountType.student, AccountType.teacher],
  refreshInterval: Duration(minutes: 10),
  settings: [
    AppletSetting<bool>(
      key: 'show_full_plan',
      label: (context) => 'Gesamten Plan anzeigen',
      description: (context) => 'Zeigt den gesamten Vertretungsplan an, anstatt nur die persönlichen einträge.',
      defaultValue: true,
    ),
  ],
  bodyBuilder: (context, accountType) {
    return Container();
  },
);
import 'package:flutter/material.dart';
import 'package:sph_plan/applets/definitions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/database/account_preferences_database/stored_preference.dart';
import '../../shared/account_types.dart';

final substitutionDefinition = AppletDefinition(
  appletPhpUrl: 'vertretungsplan.php',
  icon: Icon(Icons.people),
  selectedIcon: Icon(Icons.people_outline),
  appletType: AppletType.withBottomNavigation,
  addDivider: true,
  label: (context) => AppLocalizations.of(context)!.substitutions,
  supportedAccountTypes: [AccountType.student, AccountType.teacher],
  refreshInterval: Duration(minutes: 10),
  settings: [
    StoredPreference<bool>(
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
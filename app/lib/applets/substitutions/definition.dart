import 'package:flutter/material.dart';
import 'package:sph_plan/applets/definitions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sph_plan/applets/substitutions/parser.dart';
import 'package:sph_plan/applets/substitutions/substitutions_view.dart';

import '../../shared/account_types.dart';

final parser = SubstitutionsParser();
final substitutionDefinition = AppletDefinition(
  appletPhpUrl: 'vertretungsplan.php',
  icon: Icon(Icons.people),
  selectedIcon: Icon(Icons.people_outline),
  appletType: AppletType.nested,
  addDivider: true,
  label: (context) => AppLocalizations.of(context)!.substitutions,
  supportedAccountTypes: [AccountType.student, AccountType.teacher],
  refreshInterval: Duration(minutes: 10),
  settings: {},
  bodyBuilder: (context, accountType) {
    return SubstitutionsView();
  },
);

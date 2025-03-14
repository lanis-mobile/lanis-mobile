import 'package:flutter/material.dart';
import 'package:sph_plan/applets/abitur_helper/abitur_helper_view.dart';
import 'package:sph_plan/applets/calendar/calendar_view.dart';
import 'package:sph_plan/applets/definitions.dart';
import 'package:sph_plan/generated/l10n.dart';

import '../../models/account_types.dart';

final abiturHelperDefinition = AppletDefinition(
  appletPhpUrl: 'abiturhelfer.php',
  addDivider: false,
  appletType: AppletType.navigation,
  icon: const Icon(Icons.history_edu),
  selectedIcon: const Icon(Icons.history_edu_outlined),
  label: (context) => AppLocalizations.of(context).calendar,
  supportedAccountTypes: [AccountType.student],
  allowOffline: true,
  settingsDefaults: {},
  refreshInterval: const Duration(minutes: 1),
  bodyBuilder: (context, accountType, openDrawerCb) {
    return AbiturHelperView(openDrawerCb: openDrawerCb);
  },
);
import 'package:flutter/material.dart';
import 'package:sph_plan/applets/definitions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../shared/account_types.dart';

final calendarDefinition = AppletDefinition(
  appletPhpUrl: 'calendar.php',
  addDivider: false,
  appletType: AppletType.withBottomNavigation,
  icon: const Icon(Icons.calendar_today),
  selectedIcon: const Icon(Icons.calendar_today_outlined),
  label: (context) => AppLocalizations.of(context)!.calendar,
  supportedAccountTypes: [AccountType.student, AccountType.teacher],
  allowOffline: true,
  settings: [],
  refreshInterval: const Duration(minutes: 30),
  bodyBuilder: (context, accountType) {
    return Container();
  },
);
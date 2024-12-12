import 'package:flutter/material.dart';
import 'package:sph_plan/applets/calendar/calendar_view.dart';
import 'package:sph_plan/applets/definitions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/account_types.dart';

final calendarDefinition = AppletDefinition(
  appletPhpUrl: 'kalender.php',
  addDivider: false,
  appletType: AppletType.nested,
  icon: const Icon(Icons.calendar_today),
  selectedIcon: const Icon(Icons.calendar_today_outlined),
  label: (context) => AppLocalizations.of(context)!.calendar,
  supportedAccountTypes: [AccountType.student, AccountType.teacher, AccountType.parent],
  allowOffline: false,
  settingsDefaults: {},
  refreshInterval: const Duration(hours: 1),
  bodyBuilder: (context, accountType) {
    return CalendarView();
  },
);
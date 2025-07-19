import 'package:flutter/material.dart';
import 'package:lanis/applets/calendar/calendar_view.dart';
import 'package:lanis/applets/definitions.dart';
import 'package:lanis/generated/l10n.dart';

import '../../models/account_types.dart';

final calendarDefinition = AppletDefinition(
  appletPhpIdentifier: 'kalender.php',
  addDivider: false,
  useBottomNavigation: true,
  icon: (context) => const Icon(Icons.calendar_today),
  selectedIcon: (context) => const Icon(Icons.calendar_today_outlined),
  label: (context) => AppLocalizations.of(context).calendar,
  supportedAccountTypes: [
    AccountType.student,
    AccountType.teacher,
    AccountType.parent
  ],
  allowOffline: false,
  settingsDefaults: {},
  refreshInterval: const Duration(hours: 1),
  bodyBuilder: (context, accountType, openDrawerCb) {
    return CalendarView(openDrawerCb: openDrawerCb);
  },
);

import 'package:flutter/material.dart';
import 'package:lanis/applets/definitions.dart';
import 'package:lanis/applets/timetable/student/student_timetable_view.dart';
import 'package:lanis/generated/l10n.dart';

import '../../models/account_types.dart';

final timeTableDefinition = AppletDefinition(
  appletPhpIdentifier: 'stundenplan.php',
  icon: (context) => Icon(Icons.timelapse),
  selectedIcon: (context) => Icon(Icons.timelapse_outlined),
  useBottomNavigation: true,
  addDivider: false,
  label: (context) => AppLocalizations.of(context).timeTable,
  supportedAccountTypes: [AccountType.student],
  refreshInterval: Duration(hours: 1),
  allowOffline: true,
  settingsDefaults: {
    'student-selected-type': 'TimeTableType.own',
    'current-timetable-view': 'CalendarView.workWeek',
  },
  bodyBuilder: (context, accountType, openDrawerCb) {
    if (accountType == AccountType.student) {
      return StudentTimetableView(openDrawerCb: openDrawerCb);
    } else {
      return Placeholder();
    }
  },
);

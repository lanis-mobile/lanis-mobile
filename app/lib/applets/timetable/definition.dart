import 'package:flutter/material.dart';
import 'package:sph_plan/applets/definitions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sph_plan/applets/timetable/student/student_timetable_view.dart';

import '../../models/account_types.dart';

final timeTableDefinition = AppletDefinition(
  appletPhpUrl: 'stundenplan.php',
  icon: Icon(Icons.timelapse),
  selectedIcon: Icon(Icons.timelapse_outlined),
  appletType: AppletType.nested,
  addDivider: false,
  label: (context) => AppLocalizations.of(context)!.timeTable,
  supportedAccountTypes: [AccountType.student],
  refreshInterval: Duration(hours: 1),
  settingsDefaults: {
    'student-selected-type': 'TimeTableType.own',
  },
  bodyBuilder: (context, accountType) {
    if (accountType == AccountType.student) {
      return StudentTimetableView();
    } else {
      return Placeholder();
    }
  },
);

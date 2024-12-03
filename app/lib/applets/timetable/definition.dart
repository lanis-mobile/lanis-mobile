import 'package:flutter/material.dart';
import 'package:sph_plan/applets/definitions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sph_plan/applets/timetable/student/student_timetable_view.dart';

import '../../models/account_types.dart';
import '../../models/timetable.dart';

final timeTableDefinition = AppletDefinition(
  appletPhpUrl: 'stundenplan.php',
  icon: Icon(Icons.timelapse),
  selectedIcon: Icon(Icons.timelapse_outlined),
  appletType: AppletType.nested,
  addDivider: false,
  label: (context) => AppLocalizations.of(context)!.timeTable,
  supportedAccountTypes: [AccountType.student],
  refreshInterval: Duration(hours: 1),
  allowOffline: true,
  settingsDefaults: {
    'student-selected-type': TimeTableType.own.toString(),
  },
  bodyBuilder: (context, accountType) {
    if (accountType == AccountType.student) {
      return StudentTimetableView();
    } else {
      return Placeholder();
    }
  },
);

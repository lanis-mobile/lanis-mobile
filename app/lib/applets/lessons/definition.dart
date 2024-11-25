import 'package:flutter/material.dart';
import 'package:sph_plan/applets/definitions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sph_plan/applets/lessons/student/lessons_student_view.dart';
import 'package:sph_plan/applets/lessons/teacher/lessons_teacher_view.dart';

import '../../shared/account_types.dart';

final lessonsDefinition = AppletDefinition(
  appletPhpUrl: 'meinunterricht.php',
  addDivider: false,
  appletType: AppletType.nested,
  icon: const Icon(Icons.school),
  selectedIcon: const Icon(Icons.school_outlined),
  label: (context) => AppLocalizations.of(context)!.lessons,
  supportedAccountTypes: [AccountType.student, AccountType.teacher],
  allowOffline: false,
  settings: {},
  refreshInterval: const Duration(minutes: 15),
  bodyBuilder: (context, accountType) {
    if (accountType == AccountType.student) {
      return LessonsStudentView();
    } else if (accountType == AccountType.teacher) {
      return LessonsTeacherView();
    }
    throw UnimplementedError('This account type is not supported jet');
  },
);

import 'package:flutter/material.dart';
import 'package:lanis/generated/l10n.dart';
import 'package:lanis/applets/definitions.dart';
import 'package:lanis/applets/study_groups/student/student_study_groups_view.dart';

import '../../models/account_types.dart';

final studyGroupsDefinition = AppletDefinition(
  appletPhpIdentifier: 'lerngruppen.php',
  addDivider: false,
  useBottomNavigation: false,
  icon: (context) => const Icon(Icons.groups),
  selectedIcon: (context) => const Icon(Icons.groups_outlined),
  label: (context) => AppLocalizations.of(context).studyGroups,
  supportedAccountTypes: [AccountType.student],
  allowOffline: true,
  settingsDefaults: {
    'showExams': 'true',
  },
  refreshInterval: const Duration(minutes: 15),
  bodyBuilder: (context, accountType, openDrawerCb) {
    return StudentStudyGroupsView();
  },
);

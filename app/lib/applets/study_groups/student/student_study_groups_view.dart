import 'package:flutter/material.dart';
import 'package:sph_plan/applets/study_groups/definitions.dart';
import 'package:sph_plan/core/sph/sph.dart';
import 'package:sph_plan/widgets/combined_applet_builder.dart';

class StudentStudyGroupsView extends StatefulWidget {
  const StudentStudyGroupsView({super.key});

  @override
  State<StudentStudyGroupsView> createState() => _StudentStudyGroupsViewState();
}

class _StudentStudyGroupsViewState extends State<StudentStudyGroupsView> {
  @override
  Widget build(BuildContext context) {
    return CombinedAppletBuilder(
        parser: sph!.parser.studyGroupsStudentParser,
        phpUrl: studyGroupsDefinition.appletPhpUrl,
        settingsDefaults: studyGroupsDefinition.settingsDefaults,
        accountType: sph!.session.accountType,
        builder:
            (context, data, accountType, settings, updateSetting, refresh) {
          //
          return SizedBox();
        });
  }
}

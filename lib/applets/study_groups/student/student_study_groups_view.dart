import 'package:flutter/material.dart';
import 'package:lanis/generated/l10n.dart';
import 'package:lanis/applets/study_groups/definitions.dart';
import 'package:lanis/applets/study_groups/student/student_course_view.dart';
import 'package:lanis/applets/study_groups/student/student_exams_view.dart';
import 'package:lanis/core/sph/sph.dart';
import 'package:lanis/models/study_groups.dart';
import 'package:lanis/widgets/combined_applet_builder.dart';
import 'package:lanis/widgets/dynamic_app_bar.dart';

class StudentStudyGroupsView extends StatefulWidget {
  const StudentStudyGroupsView({super.key});

  @override
  State<StudentStudyGroupsView> createState() => _StudentStudyGroupsViewState();
}

class _StudentStudyGroupsViewState extends State<StudentStudyGroupsView> {
  Widget _buildToggleExamsButton(
      BuildContext context, Map settings, Function updateSetting) {
    final showExams = settings['showExams'] == 'true';
    return Tooltip(
      message: showExams
          ? AppLocalizations.of(context).studyGroups
          : AppLocalizations.of(context).exams,
      child: IconButton(
        icon: Icon(
          showExams ? Icons.groups_outlined : Icons.article_outlined,
        ),
        onPressed: () => {
          updateSetting('showExams', showExams ? 'false' : 'true'),
        },
      ),
    );
  }

  void updateAppBar(Widget appBarAction, String newTitle) {
    AppBarController.instance.remove('studentStudyGroups');
    AppBarController.instance.add('studentStudyGroups', appBarAction);
    AppBarController.instance.setOverrideTitle(newTitle);
  }

  @override
  Widget build(BuildContext context) {
    return CombinedAppletBuilder(
        parser: sph!.parser.studyGroupsStudentParser,
        phpUrl: studyGroupsDefinition.appletPhpIdentifier,
        settingsDefaults: studyGroupsDefinition.settingsDefaults,
        accountType: sph!.session.accountType,
        builder:
            (context, data, accountType, settings, updateSetting, refresh) {
          List<StudentStudyGroupsContainer> studyData = data
              .expand((studyGroup) => studyGroup.exams.map(
                    (exam) => StudentStudyGroupsContainer(
                      halfYear: studyGroup.halfYear,
                      courseName: studyGroup.courseName,
                      teacher: studyGroup.teacher,
                      teacherKuerzel: studyGroup.teacherKuerzel,
                      exam: exam,
                    ),
                  ))
              .toList();

          studyData.sort((a, b) => a.exam.date.compareTo(b.exam.date));
          updateAppBar(
            _buildToggleExamsButton(context, settings, updateSetting),
            settings['showExams'] != 'true'
                ? AppLocalizations.of(context).studyGroups
                : AppLocalizations.of(context).exams,
          );
          return settings['showExams'] == 'true'
              ? StudentExamsView(studyData: studyData)
              : StudentCourseView(studyData: data);
        });
  }
}

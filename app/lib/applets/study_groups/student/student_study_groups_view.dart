import 'package:flutter/material.dart';
import 'package:sph_plan/applets/study_groups/definitions.dart';
import 'package:sph_plan/applets/study_groups/student/student_exams_view.dart';
import 'package:sph_plan/core/sph/sph.dart';
import 'package:sph_plan/models/study_groups.dart';
import 'package:sph_plan/widgets/combined_applet_builder.dart';

class StudentStudyGroupsView extends StatefulWidget {
  const StudentStudyGroupsView({super.key});

  @override
  State<StudentStudyGroupsView> createState() => _StudentStudyGroupsViewState();
}

class _StudentStudyGroupsViewState extends State<StudentStudyGroupsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(studyGroupsDefinition.label(context)),
      ),
      body: CombinedAppletBuilder(
          parser: sph!.parser.studyGroupsStudentParser,
          phpUrl: studyGroupsDefinition.appletPhpUrl,
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

            return Stack(children: [
              StudentExamsView(studyData: studyData),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    spacing: 8.0,
                    children: [
                      Chip(
                        label: Text('Klausuren'),
                      ),
                      Chip(
                        label: Text('Kurse'),
                      )
                    ],
                  ),
                ],
              ),
            ]);
          }),
    );
  }
}

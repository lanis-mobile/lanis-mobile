import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/applets/study_groups/definitions.dart';
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

            return ListView.builder(
              itemCount: studyData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(studyData[index].courseName),
                          Text(studyData[index].teacher),
                          Text(DateFormat('dd.MM.yy')
                              .format(studyData[index].exam.date)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(studyData[index].exam.type),
                          studyData[index].exam.duration.isEmpty
                              ? Text(studyData[index].exam.time)
                              : Text(
                                  '${studyData[index].exam.time} (${studyData[index].exam.duration})'),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}

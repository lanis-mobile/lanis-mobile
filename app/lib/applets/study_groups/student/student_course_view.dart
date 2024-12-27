import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/models/study_groups.dart';

class StudentCourseView extends StatelessWidget {
  final List<StudentStudyGroups> studyData;
  const StudentCourseView({super.key, required this.studyData});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 42),
      itemCount: studyData.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(studyData[index].courseName,
                          style: Theme.of(context).textTheme.labelLarge),
                      Text(studyData[index].halfYear),
                    ],
                  ),
                  Row(
                    children: [
                      Text(studyData[index].teacher),
                      Text(' (${studyData[index].teacherKuerzel})'),
                    ],
                  ),
                  if (studyData[index].exams.isNotEmpty) Divider(),
                  ...[
                    for (var exam in studyData[index].exams)
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        runAlignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        direction: Axis.horizontal,
                        children: [
                          Text(exam.type),
                          exam.duration.isEmpty
                              ? Text(exam.time)
                              : Text('${exam.time} (${exam.duration})'),
                          Text(DateFormat('dd.MM.yy').format(exam.date)),
                        ],
                      ),
                  ]
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

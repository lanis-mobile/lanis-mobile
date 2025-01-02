import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/models/study_groups.dart';

class StudentCourseView extends StatelessWidget {
  final List<StudentStudyGroups> studyData;
  const StudentCourseView({super.key, required this.studyData});

  @override
  Widget build(BuildContext context) {
    String current = "";

    return ListView.builder(
      itemCount: studyData.length,
      itemBuilder: (context, index) {
        bool show = false;
        if (studyData[index].halfYear != current) {
          current = studyData[index].halfYear;
          show = true;
        }

        return Column(
          children: [
            if (show)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(studyData[index].halfYear),
              )
            else
              SizedBox(height: 8.0,),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
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
          ],
        );
      },
    );
  }
}

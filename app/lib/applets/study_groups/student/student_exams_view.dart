import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/models/study_groups.dart';

class StudentExamsView extends StatelessWidget {
  final List<StudentStudyGroupsContainer> studyData;
  const StudentExamsView({super.key, required this.studyData});

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
                      Row(
                        spacing: 4,
                        children: [
                          Text(
                              DateFormat('dd.MM.yy')
                                  .format(studyData[index].exam.date),
                              style: Theme.of(context).textTheme.labelLarge),
                          Icon(Icons.calendar_today, size: 16),
                        ],
                      ),
                    ],
                  ),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    runAlignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    direction: Axis.horizontal,
                    children: [
                      Text(studyData[index].exam.type),
                      Text(studyData[index].teacherKuerzel),
                      studyData[index].exam.duration.isEmpty
                          ? Text(studyData[index].exam.time)
                          : Text(
                              '${studyData[index].exam.time} (${studyData[index].exam.duration})'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

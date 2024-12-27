import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:sph_plan/models/study_groups.dart';

class StudentExamsView extends StatelessWidget {
  final List<StudentStudyGroupsContainer> studyData;
  const StudentExamsView({super.key, required this.studyData});

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    bool todayMarkerShown = false;
    return ListView.builder(
      itemCount: studyData.length,
      itemBuilder: (context, index) {
        bool showMarker = !todayMarkerShown &&
            studyData[index].exam.date.isAfter(today.subDays(1));
        int difference = studyData[index].exam.date.difference(today).inDays;
        if (showMarker) todayMarkerShown = true;
        return Column(
          children: [
            if (showMarker && difference != 0)
              Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    spacing: 8,
                    children: [
                      Text(DateFormat('dd.MM.yy').format(today)),
                      Expanded(child: Divider()),
                      // Show days until next exam
                      Text(AppLocalizations.of(context)!
                          .daysUntilNextExam(difference)),
                    ],
                  )),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                color: showMarker && difference == 0
                    ? Theme.of(context).colorScheme.secondaryContainer
                    : null,
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
                                  style:
                                      Theme.of(context).textTheme.labelLarge),
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
            ),
          ],
        );
      },
    );
  }
}

import 'dart:convert';

import 'package:dart_date/dart_date.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sph_plan/background_service.dart';
import 'package:sph_plan/core/sph/sph.dart';
import 'package:sph_plan/models/account_types.dart';
import 'package:sph_plan/models/study_groups.dart';

Future<void> studyCheckExams(
    SPH sph, AccountType accountType, BackgroundTaskToolkit toolkit) async {
  int checkInterval = 604800; // Check every 7 days for new exams
  // Get account data

  String? lastScanStr = (await sph.prefs.kv.get('last-exam-scan')) as String?;
  String? scheduledExamsStr =
      (await sph.prefs.kv.get('scheduled-exams')) as String?;
  int? lastScan = lastScanStr == null ? null : jsonDecode(lastScanStr);
  Map<int, ScheduledExam> scheduledExams = scheduledExamsStr == null
      ? {}
      : (jsonDecode(scheduledExamsStr) as Map<String, dynamic>)
          .map((key, value) => MapEntry(
                int.parse(key),
                ScheduledExam.fromJson(value),
              ));

  List<int> examsToRemove = [];
  for (final exam in scheduledExams.values) {
    if (DateTime.now().subDays(7).isAfter(exam.date)) {
      examsToRemove.add(exam.date.secondsSinceEpoch);

      // Send notification
      await toolkit.sendMessage(
        id: exam.date.secondsSinceEpoch % 10000,
        title: 'Exam',
        message:
            'You have an exam in ${exam.name} at ${exam.date.format('HH:mm')}',
        avoidDuplicateSending: true,
        importance: Importance.high,
      );
    }
  }

  for (int remove in examsToRemove) {
    scheduledExams.remove(remove);
  }

  if (lastScan == null ||
      DateTime.now().secondsSinceEpoch - lastScan > checkInterval) {
    final exams = await sph.parser.studyGroupsStudentParser.getHome();

    for (StudentStudyGroups exam in exams) {
      for (StudentExam e in exam.exams) {
        if (scheduledExams.containsKey(e.date.secondsSinceEpoch)) {
          continue;
        }
        if (DateTime.now().subDays(7).isAfter(e.date)) {
          print(
              'Skipping exam ${exam.courseName} at ${e.date} because it is in the past');
          continue;
        }

        final scheduledExam = ScheduledExam(
          name: exam.courseName,
          date: e.date,
          duration: e.duration,
        );

        scheduledExams[e.date.secondsSinceEpoch] = scheduledExam;
      }
    }

    // Save last scan
    await sph.prefs.kv
        .set('last-exam-scan', jsonEncode(DateTime.now().secondsSinceEpoch));
  }

  String jsonString = jsonEncode(
    scheduledExams
        .map((key, value) => MapEntry(key.toString(), value.toJson())),
  );

  // Save exams
  await sph.prefs.kv.set('scheduled-exams', jsonString);
}

class ScheduledExam {
  final String name;
  final DateTime date;
  final String? duration;

  ScheduledExam({required this.name, required this.date, this.duration});

  factory ScheduledExam.fromJson(Map<String, dynamic> json) {
    return ScheduledExam(
      name: json['name'],
      date: DateTime.parse(json['date']),
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': date.toIso8601String(),
      'duration': duration,
    };
  }
}

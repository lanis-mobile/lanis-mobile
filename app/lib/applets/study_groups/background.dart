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
  int? lastScan = sph.prefs.kv.get('last-exam-scan') as int?;
  Map<int, ScheduledExam> scheduledExams =
      sph.prefs.kv.get('scheduled-exams') as Map<int, ScheduledExam>? ?? {};

  print('Scheduled exams: $scheduledExams');

  for (final exam in scheduledExams.values) {
    if (DateTime.now().isAfter(exam.date)) {
      scheduledExams.remove(exam.date.secondsSinceEpoch);

      // Send notification
      toolkit.sendMessage(
        id: exam.date.secondsSinceEpoch % 10000,
        title: 'Exam',
        message:
            'You have an exam in ${exam.name} at ${exam.date.format('HH:mm')}',
        avoidDuplicateSending: true,
        importance: Importance.high,
      );
    }
  }

  if (lastScan == null ||
      DateTime.now().secondsSinceEpoch - lastScan > checkInterval) {
    final exams = await sph.parser.studyGroupsStudentParser.getHome();

    for (StudentStudyGroups exam in exams) {
      for (StudentExam e in exam.exams) {
        if (scheduledExams.containsKey(e.date.secondsSinceEpoch)) {
          continue;
        }
        if (DateTime.now().isAfter(e.date)) {
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

    // Save exams
    sph.prefs.kv.set('scheduled-exams', scheduledExams);

    // Save last scan
    sph.prefs.kv.set('last-exam-scan', DateTime.now().secondsSinceEpoch);
  } else {
    print('No new exams');
  }
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

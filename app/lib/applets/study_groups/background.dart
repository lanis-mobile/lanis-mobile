import 'dart:convert';

import 'package:dart_date/dart_date.dart';
import 'package:sph_plan/background_service.dart';
import 'package:sph_plan/core/sph/sph.dart';
import 'package:sph_plan/models/account_types.dart';
import 'package:sph_plan/models/study_groups.dart';
import 'package:sph_plan/utils/logger.dart';

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

  for (final exam in scheduledExams.values) {
    for (final notification in exam.notifications.entries) {
      int numSentCount = 0;
      if (notification.key < DateTime.now().secondsSinceEpoch) {
        if (!notification.value) {
          backgroundLogger
              .i("Sending notification for exam ${exam.name} at ${exam.date}");

          toolkit.sendMessage(
            title: 'Klausur in ${exam.name}',
            message:
                'Am ${exam.date.format('dd.MM.yyyy')} findet eine Klausur in ${exam.name} statt.',
            id: exam.date.secondsSinceEpoch % 10000,
          );
          exam.notifications[notification.key] = true;
        } else {
          numSentCount++;
        }
      }

      // If two notifications have been sent, remove the notification
      if (numSentCount >= 2) {
        exam.notifications.remove(notification.key);
      }
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
        if (DateTime.now().subDays(7).isAfter(e.date)) {
          backgroundLogger
              .i("Skipping exam ${exam.courseName} because it is too old");
          continue;
        }

        final scheduledExam = ScheduledExam(
            name: exam.courseName,
            date: e.date,
            duration: e.duration,
            notifications: {
              e.date.subDays(2).secondsSinceEpoch: false,
              e.date.subDays(7).secondsSinceEpoch: false,
            });

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
  final Map<int, bool> notifications;

  ScheduledExam(
      {required this.name,
      required this.date,
      this.duration,
      required this.notifications});

  factory ScheduledExam.fromJson(Map<String, dynamic> json) {
    return ScheduledExam(
      name: json['name'],
      date: DateTime.parse(json['date']),
      duration: json['duration'],
      notifications: json['notifications'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': date.toIso8601String(),
      'duration': duration,
      'notifications': notifications,
    };
  }
}

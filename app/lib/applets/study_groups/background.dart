import 'package:dart_date/dart_date.dart';
import 'package:sph_plan/background_service.dart';
import 'package:sph_plan/core/sph/sph.dart';
import 'package:sph_plan/models/account_types.dart';
import 'package:sph_plan/models/study_groups.dart';

Future<void> studyCheckExams(
    SPH sph, AccountType accountType, BackgroundTaskToolkit toolkit) async {
  int checkInterval = 604800; // Check every 7 days for new exams
  // Get account data
  int? lastScan = sph.prefs.kv.get('last-exam-scan') as int?;
  Map<String, int> scheduledExams =
      sph.prefs.kv.get('scheduled-exams') as Map<String, int>? ?? {};

  if (lastScan == null ||
      DateTime.now().secondsSinceEpoch - lastScan > checkInterval) {
    final exams = await sph.parser.studyGroupsStudentParser.getHome();

    for (StudentStudyGroups exam in exams) {
      for (StudentExam e in exam.exams) {}
    }

    // Save last scan
    sph.prefs.kv.set('last-exam-scan', DateTime.now().secondsSinceEpoch);
  } else {
    print('No new exams');
  }
}

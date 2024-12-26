import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:sph_plan/core/applet_parser.dart';
import 'package:sph_plan/models/study_groups.dart';

class StudyGroupsStudentParser extends AppletParser<List<StudentStudyGroups>> {
  StudyGroupsStudentParser(super.sph, super.appletDefinition);

  @override
  List<StudentStudyGroups> typeFromJson(String json) {
    return (jsonDecode(json) as List)
        .map((item) => StudentStudyGroups.fromJson(item))
        .toList();
  }

  @override
  Future<List<StudentStudyGroups>> getHome() async {
    Response response = await sph.session.dio
        .get('https://start.schulportal.hessen.de/lerngruppen.php');

    Document document = parse(response.data);

    Element? courses = document.getElementById('LGs');
    Element? exams = document.getElementById('klausuren');

    ExamData examData = parseExams(exams!);
    CourseData courseData = parseCourses(courses!);

    List<StudentStudyGroups> studyGroups = [];
    for (int i = 0; i < examData.data.length; i++) {
      print(examData.data.length);
      List<String> data = examData.data[i];
      String date = data[0].split(', ')[1].trim();
      // date is format DD.MM.YYYY
      DateTime day = DateTime.parse(date.split('.').reversed.join('-'));

      studyGroups.add(StudentStudyGroups(
        date: day,
        halfYear: data[1],
        courseName: data[2],
        teacher: data[3],
        teacherKuerzel: data[4],
        type: data[5],
        duration: data[6],
        exams: examData.data
            .where((element) => element[0] == date)
            .map((e) => StudentExam(
                  day: DateTime.parse(e[0]),
                  time: e[1],
                ))
            .toList(),
      ));
    }

    return studyGroups;
  }

  ExamData parseExams(Element exams) {
    List<String> examHeaders = [];
    Element? examTable = exams.querySelector('table');
    examTable!.querySelectorAll('thead tr th').forEach((element) {
      examHeaders.add(element.text.trim());
    });

    // Exams parse tbody
    List<List<String>> examData = [];
    examTable.querySelectorAll('tbody tr').forEach((element) {
      List<String> examRow = [];
      // Check if first element contains a date
      if (element
          .querySelector('td')!
          .text
          .trim()
          .contains(RegExp(r'\d{2}\.\d{2}\.\d{4}'))) {
        element.querySelectorAll('td').forEach((element) {
          examRow.add(element.text.trim());
        });
        examData.add(examRow);
      }
    });

    return ExamData(examHeaders, examData);
  }

  CourseData parseCourses(Element courses) {
    List<String> courseHeaders = [];
    courses.querySelectorAll('thead tr th').forEach((element) {
      courseHeaders.add(element.text.trim());
    });

    // Courses parse tbody
    List<List<String>> courseData = [];
    courses.querySelectorAll('tbody tr').forEach((element) {
      List<String> courseRow = [];
      element.querySelectorAll('td').forEach((element) {
        String html = element.innerHtml;
        if (html.contains('<br>')) {
          courseRow.add(html
              .split('<br>')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .join('|'));
        } else {
          courseRow.add(element.text.trim());
        }
      });
      courseData.add(courseRow);
    });

    return CourseData(courseHeaders, courseData);
  }
}

class ExamData {
  final List<String> headers;
  final List<List<String>> data;

  ExamData(this.headers, this.data);
}

class CourseData {
  final List<String> headers;
  final List<List<String>> data;

  CourseData(this.headers, this.data);
}

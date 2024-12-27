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
    for (int i = 0; i < courseData.data.length; i++) {
      List<String> data = courseData.data[i];

      String courseName = data[1].split('(')[0].trim();
      String teacher = data[2].split('(')[0].trim();
      String teacherKuerzel = data[2].split('(')[1].split(')')[0].trim();

      // Filters mapped by courseName
      List<List<String>> examsInCourse = examData.data
          .where((element) => element[1].contains(courseName))
          .toList();

      studyGroups.add(StudentStudyGroups(
        halfYear: data[0],
        courseName: courseName,
        teacher: teacher,
        teacherKuerzel: teacherKuerzel,
        exams: examsInCourse
            .map((e) => StudentExam(
                  date: DateTime.parse(
                      e[0].split(', ')[1].split('.').reversed.join('-')),
                  time: e[3],
                  type: e[2],
                  duration: e[4],
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

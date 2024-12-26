import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:sph_plan/core/applet_parser.dart';
import 'package:sph_plan/models/study_groups.dart';

class StudyGroupsStudentParser extends AppletParser<StudentStudyGroups> {
  StudyGroupsStudentParser(super.sph, super.appletDefinition);

  @override
  StudentStudyGroups typeFromJson(String json) {
    return StudentStudyGroups.fromJson(jsonDecode(json));
  }

  @override
  Future<StudentStudyGroups> getHome() async {
    Response response = await sph.session.dio
        .get('https://start.schulportal.hessen.de/lerngruppen.php');

    Document document = parse(response.data);

    Element? courses = document.getElementById('LGs');
    Element? exams = document.getElementById('klausuren');

    // Courses parse thead
    List<String> courseHeaders = [];
    courses!.querySelectorAll('thead tr th').forEach((element) {
      courseHeaders.add(element.text.trim());
    });

    courses.querySelectorAll('tbody tr').forEach((element) {
      List<String> courseData = [];
      element.querySelectorAll('td').forEach((element) {
        // If <br> tag is present see each text as its own element
        String html = element.innerHtml;
        if (html.contains('<br>')) {
          List<String> split = html.split('<br>');
          for (var element in split) {
            if (element.trim().isNotEmpty) {
              courseData.add(element.trim());
            }
          }
        } else {
          courseData.add(element.text.trim());
        }
      });
    });

    // Exams parse thead

    return StudentStudyGroups.fromJson(jsonDecode(response.data));
  }
}

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

    Element? courses = document.getElementById('kurse');
    Element? exams = document.getElementById('klausuren');

    return StudentStudyGroups.fromJson(jsonDecode(response.data));
  }
}

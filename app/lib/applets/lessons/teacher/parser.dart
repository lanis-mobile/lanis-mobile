import 'dart:io';

import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:sph_plan/applets/lessons/definition.dart';
import 'package:sph_plan/core/applet_parser.dart';
import 'package:sph_plan/models/lessons.dart';

import '../../../core/sph/sph.dart';
import '../../../shared/exceptions/client_status_exceptions.dart';

class LessonsTeacherParser extends AppletParser<Lessons> {

}
import 'package:sph_plan/applets/calendar/parser.dart';

import '../../applets/lessons/student/parser.dart';
import '../../applets/substitutions/parser.dart';

class Parsers {
  SubstitutionsParser? _substitutionsParser;
  CalendarParser? _calendarParser;
  LessonsStudentParser? _lessonsStudentParser;

  get substitutionsParser {
    _substitutionsParser ??= SubstitutionsParser();
    return _substitutionsParser;
  }

  get calendarParser {
    _calendarParser ??= CalendarParser();
    return _calendarParser;
  }

  get lessonsStudentParser {
    _lessonsStudentParser ??= LessonsStudentParser();
    return _lessonsStudentParser;
  }
}
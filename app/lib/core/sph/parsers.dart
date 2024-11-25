import 'package:sph_plan/applets/calendar/parser.dart';
import 'package:sph_plan/applets/lessons/teacher/parser.dart';
import 'package:sph_plan/applets/timetable/student/parser.dart';

import '../../applets/data_storage/parser.dart';
import '../../applets/lessons/student/parser.dart';
import '../../applets/substitutions/parser.dart';

class Parsers {
  SubstitutionsParser? _substitutionsParser;
  CalendarParser? _calendarParser;
  LessonsStudentParser? _lessonsStudentParser;
  LessonsTeacherParser? _lessonsTeacherParser;
  DataStorageParser? _dataStorageParser;
  TimetableStudentParser? _timetableStudentParser;

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

  get lessonsTeacherParser {
    _lessonsTeacherParser ??= LessonsTeacherParser();
    return _lessonsTeacherParser;
  }

  get dataStorageParser {
    _dataStorageParser ??= DataStorageParser();
    return _dataStorageParser;
  }

  get timetableStudentParser {
    _timetableStudentParser ??= TimetableStudentParser();
    return _timetableStudentParser;
  }
}
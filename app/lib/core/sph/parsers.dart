import 'package:sph_plan/applets/calendar/parser.dart';
import 'package:sph_plan/applets/conversations/parser.dart';
import 'package:sph_plan/applets/lessons/teacher/parser.dart';
import 'package:sph_plan/applets/timetable/student/parser.dart';
import 'package:sph_plan/core/sph/sph.dart';

import '../../applets/data_storage/parser.dart';
import '../../applets/lessons/student/parser.dart';
import '../../applets/substitutions/parser.dart';

class Parsers {
  SPH sph;

  SubstitutionsParser? _substitutionsParser;
  CalendarParser? _calendarParser;
  LessonsStudentParser? _lessonsStudentParser;
  LessonsTeacherParser? _lessonsTeacherParser;
  DataStorageParser? _dataStorageParser;
  TimetableStudentParser? _timetableStudentParser;
  ConversationsParser? _conversationsParser;

  Parsers({required this.sph});

  SubstitutionsParser get substitutionsParser {
    _substitutionsParser ??= SubstitutionsParser(sph);
    return _substitutionsParser!;
  }

  CalendarParser get calendarParser {
    _calendarParser ??= CalendarParser(sph);
    return _calendarParser!;
  }

  LessonsStudentParser get lessonsStudentParser {
    _lessonsStudentParser ??= LessonsStudentParser(sph);
    return _lessonsStudentParser!;
  }

  LessonsTeacherParser get lessonsTeacherParser {
    _lessonsTeacherParser ??= LessonsTeacherParser(sph);
    return _lessonsTeacherParser!;
  }

  DataStorageParser get dataStorageParser {
    _dataStorageParser ??= DataStorageParser(sph);
    return _dataStorageParser!;
  }

  TimetableStudentParser get timetableStudentParser {
    _timetableStudentParser ??= TimetableStudentParser(sph);
    return _timetableStudentParser!;
  }

  ConversationsParser get conversationsParser {
    _conversationsParser ??= ConversationsParser(sph);
    return _conversationsParser!;
  }
}
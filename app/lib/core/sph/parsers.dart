import 'package:sph_plan/applets/calendar/parser.dart';

import '../../applets/substitutions/parser.dart';

class Parsers {
  SubstitutionsParser? _substitutionsParser;
  CalendarParser? _calendarParser;

  get substitutionsParser {
    _substitutionsParser ??= SubstitutionsParser();
    return _substitutionsParser;
  }

  get calendarParser {
    _calendarParser ??= CalendarParser();
    return _calendarParser;
  }
}
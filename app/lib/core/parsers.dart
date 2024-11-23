

import '../applets/substitutions/parser.dart';

class Parsers {
  static SubstitutionsParser? _substitutionsParser;

  static get substitutionsParser {
    _substitutionsParser ??= SubstitutionsParser();
    return _substitutionsParser;
  }
}
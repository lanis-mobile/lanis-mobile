import '../../applets/substitutions/parser.dart';

class Parsers {
  SubstitutionsParser? _substitutionsParser;

  get substitutionsParser {
    _substitutionsParser ??= SubstitutionsParser();
    return _substitutionsParser;
  }
}
class OwnFile {
  final String name;
  final String url;
  final String time;
  final String index;
  String? comment;

  OwnFile({required this.name, required this.url, required this.time, required this.index, this.comment});
}

class PublicFile {
  final String name;
  final String url;
  final String index;
  final String person;

  PublicFile({required this.name, required this.url, required this.person, required this.index});
}
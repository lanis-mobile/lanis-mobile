// Peak code design

class UploadFile {
  final String name;
  final String url;
  final String index;

  UploadFile({required this.name, required this.url, required this.index});
}

class OwnFile extends UploadFile {
  final String time;
  final String? comment;

  OwnFile({required super.name, required super.url, required super.index, required this.time, this.comment});
}

class PublicFile extends UploadFile {
  final String person;

  PublicFile({required super.name, required super.url, required super.index, required this.person});
}

class FileStatus {
  final String name;
  final String status; //erfolgreich or fehlgeschlagen
  final String? message;

  FileStatus({required this.name, required this.status, this.message});
}
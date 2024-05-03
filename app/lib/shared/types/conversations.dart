class SearchEntry {
  final String id;
  final String name;

  SearchEntry({required this.id, required this.name});
}

enum ChatType {
  noAnswerAllowed,
  privateAnswerOnly,
  groupOnly,
  openChat
}
class SearchEntry {
  final String id;
  final String name;

  SearchEntry({required this.id, required this.name});
}

class PartialChat {
  final ChatType type;
  final String subject;
  final List<String> receivers;

  PartialChat({required this.type, required this.subject, required this.receivers});
}

enum ChatType {
  noAnswerAllowed("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed placerat euismod lacus."),
  privateAnswerOnly("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed placerat euismod lacus."),
  groupOnly("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed placerat euismod lacus."),
  openChat("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed placerat euismod lacus.");

  final String description;

  const ChatType(this.description);
}
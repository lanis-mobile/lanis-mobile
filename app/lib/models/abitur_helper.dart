class AbiturRow {
  final AbiturRowType type;

  final DateTime? date;
  final String? room;
  final String? grade;

  final String subject;
  final String inspector;

  // For oral exams only
  final String? protocol;
  final String? chair;

  // Calculated points
  final int? basePoints;
  final int? multiplicatedPoints;

  AbiturRow({
    required this.type,
    this.date,
    this.room,
    this.grade,
    required this.subject,
    required this.inspector,
    this.protocol,
    this.chair,
    this.basePoints,
    this.multiplicatedPoints
  });
}

enum AbiturRowType {
  written,
  oral
}
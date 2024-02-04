enum LoadModeEnum {
  fast("fast"),
  full("full");

  final String name;
  const LoadModeEnum(this.name);

  factory LoadModeEnum.fromName(String name) {
    return values.firstWhere((e) => e.name == name);
  }
}
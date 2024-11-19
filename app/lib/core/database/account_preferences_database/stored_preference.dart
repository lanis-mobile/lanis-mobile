
import '../../../applets/definitions.dart';

class StoredPreference<T> {
  final String key;
  final StringBuildContextCallback label;
  final StringBuildContextCallback description;
  final T defaultValue;

  StoredPreference({
    required this.key,
    required this.label,
    required this.description,
    required this.defaultValue,
  });
}
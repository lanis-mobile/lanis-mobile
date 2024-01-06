import 'package:flutter/material.dart';
import 'package:sph_plan/client/storage.dart';

ThemeData getThemeData(ColorScheme colorScheme) {
  return ThemeData(
    colorScheme: colorScheme,
    inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
  );
}

class Themes {
  static ThemeData lightTheme = getThemeData(ColorScheme.fromSeed(seedColor: Colors.blueAccent));
  static ThemeData darkTheme = getThemeData(ColorScheme.fromSeed(seedColor: Colors.blueAccent, brightness: Brightness.dark));
}

class ThemeModeNotifier {
  static ValueNotifier<ThemeMode> notifier = ValueNotifier<ThemeMode>(ThemeMode.system);

  static void _notify(String theme) {
    if (theme == "dark") {
      notifier.value = ThemeMode.dark;
    } else if (theme == "light") {
      notifier.value = ThemeMode.light;
    } else {
      notifier.value = ThemeMode.system;
    }
  }

  static void initThemeMode() async {
    String theme = await globalStorage.read(key: "theme") ?? "system";
    _notify(theme);
  }

  static void setThemeMode(String theme) async {
    await globalStorage.write(key: "theme", value: theme);
    _notify(theme);
  }
}
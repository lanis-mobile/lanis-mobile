import 'package:flutter/material.dart';
import 'package:sph_plan/client/storage.dart';

// The basic theme, global theme data changes should be put here.
ThemeData getThemeData(ColorScheme colorScheme) {
  return ThemeData(
    colorScheme: colorScheme,
    inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
  );
}

// Used for ColorModeNotifier to set the app theme dynamically
class Themes {
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;

  Themes(this.lightTheme, this.darkTheme);

  static Themes get standardTheme {
    const lanisDarkCyan = Color(0xFF008ba3);

    return Themes(
        getThemeData(ColorScheme.fromSeed(seedColor: lanisDarkCyan)),
        getThemeData(ColorScheme.fromSeed(seedColor: lanisDarkCyan, brightness: Brightness.dark)),
    );
  }

  static Themes dynamicTheme = Themes(null, null); // Will be later set by DynamicColorBuilder in main.dart App()
}

class ColorModeNotifier {
  static ValueNotifier<Themes> notifier = ValueNotifier<Themes>(Themes.standardTheme);

  static void setStandard() async {
    await globalStorage.write(key: "color", value: "standard");
    notifier.value = Themes.standardTheme;
  }

  static void setDynamic() async {
    await globalStorage.write(key: "color", value: "dynamic");
    notifier.value = Themes.dynamicTheme;
  }

  static void init() async {
    String mode = await globalStorage.read(key: "color") ?? "standard";
    if (mode == "standard") {
      notifier.value = Themes.standardTheme;
      // Dynamic theme will be set later by DynamicColorBuilder, bc we don't get the dynamic theme on startup.
    }
  }
}

// For setting the themeMode of MaterialApp dynamically
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

  static void init() async {
    String theme = await globalStorage.read(key: "theme") ?? "system";
    _notify(theme);
  }

  static void set(String theme) async {
    await globalStorage.write(key: "theme", value: theme);
    _notify(theme);
  }
}
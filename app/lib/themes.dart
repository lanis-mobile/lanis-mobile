import 'package:flutter/material.dart';

// Only a collection of themes
// Used for ColorModeNotifier to set the app theme dynamically
class Themes {
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;

  Themes(this.lightTheme, this.darkTheme);

  static Themes getNewTheme(Color seedColor) {
    // The basic theme, global theme data changes should be put here.
    ThemeData basicTheme(Brightness brightness) {
      return ThemeData(
        colorScheme:
          ColorScheme.fromSeed(seedColor: seedColor, brightness: brightness),
        inputDecorationTheme:
          const InputDecorationTheme(border: OutlineInputBorder()),
      );
    }

    return Themes(
      basicTheme(Brightness.light),
      basicTheme(Brightness.dark),
    );
  }

  static final Map<String, Themes> flutterColorThemes = {
    "pink": getNewTheme(Colors.pink),
    "red": getNewTheme(Colors.red),
    "orange": getNewTheme(Colors.orange),
    "yellow": getNewTheme(Colors.yellow),
    "lime": getNewTheme(Colors.lime),
    "light_green": getNewTheme(Colors.lightGreen),
    "green": getNewTheme(Colors.green),
    "teal": getNewTheme(Colors.teal),
    "cyan": getNewTheme(Colors.cyan),
    "blue": getNewTheme(Colors.blue),
    "indigo": getNewTheme(Colors.indigo),
    "purple": getNewTheme(Colors.purple),
  };

  // Will be later set by DynamicColorBuilder in main.dart App().
  static Themes dynamicTheme = Themes(null, null);

  // Will be set by ColorModeNotifier.init() or _getSchoolTheme() in client.dart.
  static Themes schoolTheme = Themes(null, null);

  static Themes standardTheme = getNewTheme(Colors.deepPurple);

  static Themes getAmoledThemes() {
    // Colors for Amoled Mode
    final Map<String, Color> amoledColors = {
      "background": Colors.black,
      "secondary": const Color(0xFF0f0f0f),
      "third": const Color(0xFF0a0a0a),
    };

    return Themes(
      Themes.standardTheme.lightTheme,
      Themes.standardTheme.darkTheme?.copyWith(
        // Amoled Background & Themes for required Components
        scaffoldBackgroundColor: amoledColors["background"],
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: amoledColors["background"],
        ),
        navigationDrawerTheme: NavigationDrawerThemeData(
          backgroundColor: amoledColors["background"],
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: amoledColors["background"],
          surfaceTintColor: amoledColors["background"],
        ),
        dialogTheme: DialogTheme(
          backgroundColor: amoledColors["secondary"],
          surfaceTintColor: amoledColors["secondary"],
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: amoledColors["third"],
          surfaceTintColor: amoledColors["third"],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';


enum AmoledColor {
  background,
  secondary,
  third
}

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
    "rot": getNewTheme(Colors.red),
    "dunkelorange": getNewTheme(Colors.deepOrange),
    "orange": getNewTheme(Colors.orange),
    "gelb": getNewTheme(Colors.yellow),
    "lindgrün": getNewTheme(Colors.lime),
    "hellgrün": getNewTheme(Colors.lightGreen),
    "grün": getNewTheme(Colors.green),
    "seegrün": getNewTheme(Colors.teal),
    "türkis": getNewTheme(Colors.cyan),
    "hellblau": getNewTheme(Colors.lightBlue),
    "blau": getNewTheme(Colors.blue),
    "indigoblau": getNewTheme(Colors.indigo),
    "lila": getNewTheme(Colors.purple),
    "braun": getNewTheme(Colors.brown[900]!),
  };

  // Will be later set by DynamicColorBuilder in main.dart App().
  static Themes dynamicTheme = Themes(null, null);

  // Will be set by ColorModeNotifier.init() or _getSchoolTheme() in client.dart.
  static Themes schoolTheme = Themes(null, null);

  static Themes standardTheme = getNewTheme(Colors.deepPurple);

  static Themes getAmoledThemes(Themes themes) {
    // Colors for Amoled Mode
    final Map<AmoledColor, Color> amoledColors = {
      AmoledColor.background: Colors.black,
      AmoledColor.secondary: const Color(0xFF0f0f0f),
      AmoledColor.third: const Color(0xFF0a0a0a),
    };

    return Themes(
      themes.lightTheme,
      themes.darkTheme?.copyWith(
        // Amoled Background & Themes for required Components
        scaffoldBackgroundColor: amoledColors[AmoledColor.background],
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: amoledColors[AmoledColor.background],
        ),
        navigationDrawerTheme: NavigationDrawerThemeData(
          backgroundColor: amoledColors[AmoledColor.background],
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: amoledColors[AmoledColor.background],
          surfaceTintColor:amoledColors[AmoledColor.background],
        ),
        dialogTheme: DialogTheme(
          backgroundColor: amoledColors[AmoledColor.secondary],
          surfaceTintColor: amoledColors[AmoledColor.secondary],
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: amoledColors[AmoledColor.third],
          surfaceTintColor: amoledColors[AmoledColor.third],
        ),
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: themes.darkTheme!.colorScheme.primary,
          onPrimary: themes.darkTheme!.colorScheme.onPrimary,
          secondary: themes.darkTheme!.colorScheme.secondaryContainer,
          onSecondary: themes.darkTheme!.colorScheme.onSecondaryContainer,
          error: themes.darkTheme!.colorScheme.error,
          onError: themes.darkTheme!.colorScheme.onError,
          surface: themes.darkTheme!.colorScheme.surface,
          onSurface: themes.darkTheme!.colorScheme.onSurface,
          surfaceContainerHigh: amoledColors[AmoledColor.background],
          surfaceContainerLow: amoledColors[AmoledColor.secondary],
          surfaceContainerLowest: amoledColors[AmoledColor.third],
        )
      ),
    );
  }
}

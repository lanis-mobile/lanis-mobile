import 'package:flutter/material.dart';

class RandomColor {
  static ColorPair randomColor(String seed) {
    final int hash = seed.hashCode;
    final int r = (hash & 0xFF0000) >> 16;
    final int g = (hash & 0x00FF00) >> 8;
    final int b = (hash & 0x0000FF);
    return ColorPair(Color.fromARGB(255, r, g, b));
  }
}

class ColorPair {
  final Color primary;
  Color get secondary => primary.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  Color get inversePrimary => Color.fromARGB(255, 255 - primary.red, 255 - primary.green, 255 - primary.blue).withOpacity(0.75);

  ColorPair(this.primary);
}
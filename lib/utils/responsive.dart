import 'package:flutter/material.dart';
import 'package:lanis/utils/logger.dart';

class Responsive {
  /// Use this for the main layout to determine if the device is a tablet or not.
  static bool isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width > 600;
  }

  /// Use this for the nested applets to determine if the device is a tablet or not.
  static bool isTabletApplet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    logger.d('isTabletApplet: ${size.width}');
    return size.width > 660.0;
  }
}

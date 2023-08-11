  import 'package:flutter/material.dart';

Color getForegroundColor(Color backgroundColor) {
    // Calculate luminance of the background color
    double luminance = backgroundColor.computeLuminance();

    // Choose white or black based on background luminance
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

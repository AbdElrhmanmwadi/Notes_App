import 'package:flutter/material.dart';

/// Curated set of note background colours. `null` represents the default
/// (theme surface) colour. Stored in the DB as an ARGB int.
class NotePalette {
  NotePalette._();

  static const List<Color?> colors = [
    null, // default / no colour
    Color(0xFFFFF8B8), // yellow
    Color(0xFFFFD8B8), // peach
    Color(0xFFFFC9C9), // red
    Color(0xFFD3F8E2), // green
    Color(0xFFC9E7FF), // blue
    Color(0xFFE7D8FF), // purple
    Color(0xFFF1F1F1), // grey
  ];
}

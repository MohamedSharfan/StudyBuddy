import 'package:flutter/material.dart';

IconData subjectIcon(String key) {
  return switch (key) {
    'atom' => Icons.science_rounded,
    'calculate' => Icons.calculate_rounded,
    'menu_book' => Icons.menu_book_rounded,
    'translate' => Icons.translate_rounded,
    'history_edu' => Icons.history_edu_rounded,
    'devices' => Icons.devices_rounded,
    _ => Icons.school_rounded,
  };
}

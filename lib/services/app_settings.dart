import 'package:flutter/material.dart';

class AppSettings {
  static final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
  static final fontScale = ValueNotifier<double>(1.0);
}

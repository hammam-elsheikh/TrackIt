import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  double fontScale = 1.0;

  void setThemeMode(ThemeMode? mode) {
    if (mode != null) {
      themeMode = mode;
      notifyListeners();
    }
  }

  void setFontScale(double scale) {
    fontScale = scale;
    notifyListeners();
  }
}

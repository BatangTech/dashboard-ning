import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  MaterialColor _primaryColor = Colors.blue;

  ThemeMode get themeMode => _themeMode;
  MaterialColor get primaryColor => _primaryColor;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setPrimaryColor(MaterialColor color) {
    _primaryColor = color;
    notifyListeners();
  }
}

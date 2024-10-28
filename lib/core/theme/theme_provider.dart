import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gemini_ai/core/constant/hive_boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkTheme = false;
  final Box themeBox = Hive.box(HiveBoxes.themeMode);

  bool get isDarkTheme => _isDarkTheme;

  ThemeProvider() {
    getThemeMode();
  }

  static Future<void> initHive() async {
    // Initialize Hive
    await Hive.initFlutter();
    await Hive.openBox(HiveBoxes.themeMode);
  }

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    themeBox.put('isDarkTheme', _isDarkTheme);
    notifyListeners();
  }

  void getThemeMode() {
    if (themeBox.isOpen) {
      _isDarkTheme = themeBox.get('isDarkTheme', defaultValue: false);
      log("Theme Mode: $_isDarkTheme");
    }
  }

  void setThemeMode(bool isDarkTheme) {
    if (themeBox.isOpen) {
      _isDarkTheme = isDarkTheme;
      themeBox.put('isDarkTheme', isDarkTheme);
    }
    notifyListeners();
  }
}

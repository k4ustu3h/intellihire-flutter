import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

class ThemeController extends ValueNotifier<bool> {
  static const _keyDynamic = "useDynamicTheme";
  static const _keyDarkMode = "useDarkMode";

  bool _useDarkMode = false;

  ThemeController(super.value);

  bool get useDarkMode => _useDarkMode;

  static Future<ThemeController> load() async {
    final prefs = await SharedPreferences.getInstance();
    final useDynamic = prefs.getBool(_keyDynamic) ?? true;
    final useDark = prefs.getBool(_keyDarkMode) ?? false;
    final controller = ThemeController(useDynamic);
    controller._useDarkMode = useDark;
    return controller;
  }

  Future<void> setUseDynamicTheme(bool useDynamic) async {
    value = useDynamic;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDynamic, useDynamic);
  }

  Future<void> setUseDarkMode(bool useDark) async {
    _useDarkMode = useDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, useDark);
    notifyListeners();
  }
}

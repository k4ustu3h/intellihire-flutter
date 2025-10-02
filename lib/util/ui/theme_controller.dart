import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

class ThemeController extends ValueNotifier<bool> {
  static const _key = "useDynamicTheme";

  ThemeController(super.value);

  static Future<ThemeController> load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(_key) ?? true;
    return ThemeController(value);
  }

  Future<void> setUseDynamicTheme(bool useDynamic) async {
    value = useDynamic;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, useDynamic);
  }
}

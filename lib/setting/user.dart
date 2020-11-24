import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCache {}

class UserData {
  // ignore: close_sinks
  static final StreamController<Brightness> brightness =
      StreamController.broadcast();
  static bool isSystemThemeMode = true;
  static AsyncSnapshot snapshot;
  
  static usePrefs(Function(SharedPreferences) prefsFunc) async {
    final prefs = await SharedPreferences.getInstance();
    return prefsFunc(prefs);
  }
}

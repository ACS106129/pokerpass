import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCache {}

class UserData {
  // ignore: close_sinks
  static final StreamController<Brightness> brightness =
      StreamController.broadcast();
  static bool isSystemThemeMode = true;
  static AsyncSnapshot<Brightness> snapshot;

  /// used to store user sensitive data
  /// 
  /// user device key: DeviceKey-url-userId
  static final storage = FlutterSecureStorage();

  /// used to store user-defined preferences
  static usePrefs(Function(SharedPreferences) prefsFunc) async {
    final prefs = await SharedPreferences.getInstance();
    return prefsFunc(prefs);
  }
}

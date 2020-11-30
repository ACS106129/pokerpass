
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCache {
  static AsyncSnapshot<Brightness> snapshot;
  static bool isSystemThemeMode;
}

class UserData {
  /// used to store user sensitive data
  ///
  /// user device key: DeviceKey-url-userId
  static final storage = FlutterSecureStorage();

  /// used to request user biometrics
  static final localAuth = LocalAuthentication();

  /// used to store user-defined preferences
  static usePrefs(Function(SharedPreferences) prefsFunc) async {
    final prefs = await SharedPreferences.getInstance();
    return prefsFunc(prefs);
  }
}

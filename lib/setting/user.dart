import 'dart:async';

import 'package:flutter/cupertino.dart';

class UserCache {}

class UserData {
  // ignore: close_sinks
  static final StreamController<Brightness> brightness = StreamController.broadcast();
  static AsyncSnapshot snapshot;
  static bool isSystemThemeMode = true;
}

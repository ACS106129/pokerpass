import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Setting {
  static const height = 600.0;
  static const width = 800.0;
  static const userLabel = 'user';
  static const urlLabel = 'url';
  static const passwordLabel = 'pw';
  static const themeLabel = 'theme';
  static const deviceKeyName = 'DeviceKey';
  static final isDesktop =
      Platform.isWindows || Platform.isMacOS || Platform.isLinux;
// regular expression check when inputting
  static final userInputRegex = RegExp(r'^[a-zA-Z0-9]{0,20}');
  static final passwordInputRegex = RegExp(r'^[a-zA-Z0-9]{0,15}');
  static final urlInputRegex = RegExp(r'^[-a-zA-Z0-9@:%._\+~#=&?/()]{0,320}');
// regular expression check finish input
  static final userRegex = RegExp(r'^[a-zA-Z0-9]{8,20}');
  static final passwordRegex = RegExp(r'^[a-zA-Z0-9]{8,15}');
  static final urlRegex = RegExp(
      r'^(https?:\/\/(www\.)?)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)');
  static final bgColor = CupertinoDynamicColor.withBrightness(
    color: Colors.white,
    darkColor: Colors.grey.shade900,
  );
  static final connectSessionButtonColor = CupertinoDynamicColor.withBrightness(
    color: Colors.blue.shade600,
    darkColor: Colors.blue.shade300,
  );
  static final loadingColor = CupertinoDynamicColor.withBrightness(
    color: Colors.black26,
    darkColor: Colors.white10,
  );
  static final placeholderColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.placeholderText,
    darkColor: Colors.white70,
  );
  static final promptTextColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.black,
    darkColor: CupertinoColors.white,
  );
  static final registerButtonColor = CupertinoDynamicColor.withBrightness(
    color: Colors.black54,
    darkColor: Colors.white70,
  );
  static final iconColor = CupertinoDynamicColor.withBrightness(
    color: Colors.blue.shade600,
    darkColor: Colors.blue.shade300,
  );
  static final settingButtonColor = CupertinoDynamicColor.withBrightness(
    color: Colors.yellow.shade600,
    darkColor: Colors.yellow.shade300,
  );
  static final submitButtonColor = CupertinoDynamicColor.withBrightness(
    color: Colors.green.shade600,
    darkColor: Colors.green.shade300,
  );
}

class Config {
  static Brightness platformBrightness =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window)
          .platformBrightness;
  static bool isDebugModeOn = false;
}

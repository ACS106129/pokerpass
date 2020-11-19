import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const height = 600.0;
const width = 800.0;
const userLabel = 'user';
const urlLabel = 'url';
const passwordLabel = 'pw';
final isDesktop = Platform.isWindows || Platform.isMacOS || Platform.isLinux;
// regular expression check when inputting
final userInputRegex = RegExp(r'^[a-zA-Z0-9]{0,20}');
final passwordInputRegex = RegExp(r'^[a-zA-Z0-9]{0,15}');
final urlInputRegex = RegExp(r'^[-a-zA-Z0-9@:%._\+~#=&?/()]{0,320}');
// regular expression check finish input
final userRegex = RegExp(r'^[a-zA-Z0-9]{8,20}');
final passwordRegex = RegExp(r'^[a-zA-Z0-9]{8,15}');
final urlRegex = RegExp(
    r'^(https?:\/\/(www\.)?)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)');
final loadingColor = CupertinoDynamicColor.withBrightness(
  color: Colors.black26,
  darkColor: Colors.white10,
);
final placeholderColor = CupertinoDynamicColor.withBrightness(
  color: CupertinoColors.placeholderText,
  darkColor: Colors.white70,
);
final promptTextColor = CupertinoDynamicColor.withBrightness(
  color: CupertinoColors.black,
  darkColor: CupertinoColors.white,
);
final iconColor = CupertinoDynamicColor.withBrightness(
  color: Colors.blue.shade600,
  darkColor: Colors.blue.shade300,
);

class DebugConfig {
  static const _isModeOn = false;
  static const brightness = _isModeOn ? Brightness.dark : null;
}

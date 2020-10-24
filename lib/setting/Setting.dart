import 'dart:io';

import 'package:flutter/cupertino.dart';

const height = 600.0;
const width = 800.0;
final isDesktop = Platform.isWindows || Platform.isMacOS || Platform.isLinux;

class DebugConfig {
  static const _isModeOn = false;
  static const brightness = _isModeOn ? Brightness.dark : null;
}

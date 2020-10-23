import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerpass/setting/Setting.dart' as setting;
import 'package:window_size/window_size.dart';

import 'home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // windows sizebox will be disabled, others preserve it
  if (setting.isDesktop) {
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
          center: screen.frame.center,
          width: setting.width,
          height: setting.height));
    });
    setWindowTitle('PokerPass');
    setWindowMinSize(Size(setting.width, setting.height));
    setWindowMaxSize(Size(setting.width, setting.height));
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'PokerPass System',
      theme: CupertinoThemeData(
        brightness: setting.isTest ? Brightness.dark : null,
        scaffoldBackgroundColor: CupertinoDynamicColor.withBrightness(
          color: Colors.white,
          darkColor: Colors.grey.shade900,
        ),
      ),
      home: HomePage(title: 'PokerPass'),
    );
  }
}

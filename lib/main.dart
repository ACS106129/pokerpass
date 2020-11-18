import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerpass/2FA/qrcode_page.dart';
import 'package:pokerpass/PC/pc_page.dart';
import 'package:pokerpass/home_page.dart';
import 'package:pokerpass/login_page.dart';
import 'package:pokerpass/register_page.dart';
import 'package:pokerpass/setting/Setting.dart' as setting;
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // windows sizebox will be disabled, others preserve it
  if (setting.isDesktop) {
    setWindowTitle('PokerPass');
    setWindowFrame(Rect.fromCenter(
        center: (await getCurrentScreen()).frame.center,
        width: setting.width,
        height: setting.height));
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
        brightness: setting.DebugConfig.brightness,
        scaffoldBackgroundColor: CupertinoDynamicColor.withBrightness(
          color: Colors.white,
          darkColor: Colors.grey.shade900,
        ),
      ),
      routes: {
        LoginPage.id: (context) => LoginPage(),
        RegisterPage.id: (context) => RegisterPage(),
        QRCodePage.id: (context) => QRCodePage(),
        PCPage.id: (context) => PCPage(),
      },
      home: HomePage(),
    );
  }
}

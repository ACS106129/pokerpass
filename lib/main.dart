import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerpass/page/2FA/qrcode_page.dart';
import 'package:pokerpass/page/PC/pc_page.dart';
import 'package:pokerpass/page/home_page.dart';
import 'package:pokerpass/page/mode_page.dart';
import 'package:pokerpass/page/register_page.dart';
import 'package:pokerpass/page/setting_page.dart';
import 'package:pokerpass/setting/setting.dart' as setting;
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
  Widget build(final BuildContext context) {
    return CupertinoApp(
      title: 'PokerPass',
      theme: CupertinoThemeData(
        brightness: setting.DebugConfig.brightness,
        scaffoldBackgroundColor: CupertinoDynamicColor.withBrightness(
          color: Colors.white,
          darkColor: Colors.grey.shade900,
        ),
      ),
      builder: BotToastInit(),
      routes: {
        ModePage.id: (context) => ModePage(),
        RegisterPage.id: (context) => RegisterPage(),
        SettingPage.id: (context) => SettingPage(),
        QRCodePage.id: (context) => QRCodePage(),
        PCPage.id: (context) => PCPage(),
      },
      navigatorObservers: [
        BotToastNavigatorObserver(),
      ],
      home: HomePage(),
    );
  }
}

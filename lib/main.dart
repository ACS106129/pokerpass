import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerpass/page/finish/finish_page.dart';
import 'package:pokerpass/page/home_page.dart';
import 'package:pokerpass/page/mode/PC/pc_page.dart';
import 'package:pokerpass/page/mode/mode_page.dart';
import 'package:pokerpass/page/qrcode_page.dart';
import 'package:pokerpass/page/register/binding_page.dart';
import 'package:pokerpass/page/register/register_page.dart';
import 'package:pokerpass/page/setting_page.dart';
import 'package:pokerpass/setting/setting.dart';
import 'package:pokerpass/setting/user.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // windows sizebox will be disabled, others preserve it
  if (Setting.isDesktop) {
    setWindowTitle('PokerPass');
    setWindowFrame(Rect.fromCenter(
        center: (await getCurrentScreen()).frame.center,
        width: Setting.width,
        height: Setting.height));
    setWindowMinSize(Size(Setting.width, Setting.height));
    setWindowMaxSize(Size(Setting.width, Setting.height));
  }
  // load media
  await Flame.images
      .loadAll(['spade.png', 'heart.png', 'diamond.png', 'club.png']);
  runApp(PokerPassApp());
}

class PokerPassApp extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return StreamBuilder<Brightness>(
      initialData: Config.platformBrightness,
      stream: Config.brightnessStream.stream,
      builder: (context, snapshot) {
        UserCache.snapshot = snapshot;
        return CupertinoApp(
          title: 'PokerPass',
          theme: CupertinoThemeData(
            brightness: snapshot.data,
            scaffoldBackgroundColor:
                CupertinoDynamicColor.resolve(Setting.bgColor, context),
          ),
          builder: BotToastInit(),
          routes: {
            ModePage.id: (_) => ModePage(),
            RegisterPage.id: (_) => RegisterPage(),
            BindingPage.id: (_) => BindingPage(),
            SettingPage.id: (_) => SettingPage(),
            QRCodePage.id: (_) => QRCodePage(),
            PCPage.id: (_) => PCPage(),
            FinishPage.id: (_) => FinishPage(),
          },
          navigatorObservers: [
            BotToastNavigatorObserver(),
          ],
          home: HomePage(),
        );
      },
    );
  }
}

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pokerpass/page/2FA/qrcode_page.dart';
import 'package:pokerpass/page/PC/pc_page.dart';
import 'package:pokerpass/setting/setting.dart' as setting;
import 'package:pokerpass/utility/area.dart';
import 'package:qrscan/qrscan.dart';

class ModePage extends StatefulWidget {
  static const id = 'mode_page';

  ModePage({final Key key}) : super(key: key);
  @override
  _ModePageState createState() => _ModePageState();
}

class _ModePageState extends State<ModePage> {
  @override
  void initState() {
    super.initState();
    BotToast.showText(text: '已連線');
  }

  @override
  Widget build(final BuildContext context) {
    return WillPopScope(
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          previousPageTitle: '中斷',
          middle: Text('選擇登入方式'),
        ),
        child: SafeArea(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) => modePageContent(
                context,
                Size(constraints.maxWidth, constraints.maxHeight),
              ),
            ),
          ),
        ),
      ),
      onWillPop: () async {
        return await showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('警告'),
            content: const Text('中斷Session連線?'),
            actions: [
              CupertinoDialogAction(
                child: const Text('取消'),
                onPressed: () => Navigator.pop(context, false),
              ),
              CupertinoDialogAction(
                child: const Text('中斷'),
                onPressed: () {
                  // disconnect session login
                  BotToast.showLoading(
                    animationDuration: Duration(milliseconds: 100),
                    animationReverseDuration: Duration(milliseconds: 100),
                    backButtonBehavior: BackButtonBehavior.none,
                    backgroundColor: CupertinoDynamicColor.resolve(
                        setting.loadingColor, context),
                    duration: Duration(milliseconds: 400),
                    onClose: () => WidgetsBinding.instance.addPostFrameCallback(
                      (_) async {
                        Navigator.pop(context, true);
                        BotToast.showText(text: '已中斷連線');
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget modePageContent(final BuildContext context, final Size contentSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: getSafeArea(context).width * 0.7,
          child: Column(
            children: [
              // PokerPC or PokerGO mode
              setting.isDesktop
                  ? CupertinoButton(
                      onPressed: () async {
                        // server number, session id and client number
                        var result =
                            await Navigator.pushNamed(context, PCPage.id);
                      },
                      child: Text(
                        'PC',
                        style: TextStyle(fontSize: 20),
                      ),
                      color: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 120,
                        vertical: 20,
                      ),
                    )
                  : CupertinoButton(
                      onPressed: () {},
                      child: Text(
                        'GO',
                        style: TextStyle(fontSize: 20),
                      ),
                      color: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 120,
                        vertical: 20,
                      ),
                    ),
              SizedBox(
                height: getSafeArea(context).height / 15,
              ),
              // Poker2FA mode
              CupertinoButton(
                onPressed: () async {
                  if (!setting.isDesktop) {
                    if (await Permission.camera.status.isGranted) {
                      var result = await Navigator.pushNamed(
                          context, QRCodePage.id,
                          arguments: await scan());
                    } else {
                      await showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: Text('相機權限要求'),
                          content: Text('該應用需要相機進行QRCode掃描'),
                          actions: [
                            CupertinoDialogAction(
                              child: Text('取消'),
                              onPressed: () => Navigator.pop(context),
                            ),
                            CupertinoDialogAction(
                              child: Text('設定'),
                              onPressed: () => openAppSettings(),
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    var result =
                        await Navigator.pushNamed(context, QRCodePage.id);
                  }
                },
                child: Text(
                  '2FA By QRCODE',
                  style: TextStyle(fontSize: 20),
                ),
                color: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 65,
                  vertical: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

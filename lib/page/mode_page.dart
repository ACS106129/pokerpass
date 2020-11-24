import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  bool isAbsorbTouch = false;

  @override
  void initState() {
    super.initState();
    BotToast.showText(text: '已連線');
  }

  @override
  Widget build(final BuildContext context) {
    return AbsorbPointer(
      absorbing: isAbsorbTouch,
      child: WillPopScope(
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
          await showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('警告'),
              content: const Text('中斷Session連線?'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('取消'),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoDialogAction(
                  child: const Text('中斷'),
                  onPressed: () {
                    BotToast.showLoading(
                      crossPage: false,
                      animationDuration: Duration(milliseconds: 100),
                      animationReverseDuration: Duration(milliseconds: 100),
                      backButtonBehavior: BackButtonBehavior.none,
                      backgroundColor: CupertinoDynamicColor.resolve(
                          setting.loadingColor, context),
                      duration: Duration(milliseconds: 400),
                    );
                    // disconnect session login
                    Future.delayed(Duration(milliseconds: 150), () async {
                      Navigator.pop(context);
                      Navigator.pop(context, '已中斷連線');
                    });
                  },
                ),
              ],
            ),
          );
          return false;
        },
      ),
    );
  }

  Widget modePageContent(final BuildContext context, final Size contentSize) {
    return Container(
      width: getSafeArea(context).width * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // PokerPC or PokerGO mode
          setting.isDesktop
              ? CupertinoButton(
                  child: Text(
                    'PokerPC',
                    style: TextStyle(fontSize: 28),
                  ),
                  color: CupertinoColors.activeGreen,
                  onPressed: () async {
                    // server number, session id and client number
                    BotToast.showLoading(
                      crossPage: false,
                      animationDuration: Duration(milliseconds: 100),
                      animationReverseDuration: Duration(milliseconds: 100),
                      backButtonBehavior: BackButtonBehavior.none,
                      backgroundColor: CupertinoDynamicColor.resolve(
                          setting.loadingColor, context),
                      duration: Duration(milliseconds: 400),
                    );
                    Future.delayed(Duration(milliseconds: 200), () async {
                      var result =
                          await Navigator.pushNamed(context, PCPage.id);
                      if (result is String) BotToast.showText(text: result);
                    });
                  },
                  padding: EdgeInsets.symmetric(
                    vertical: contentSize.height / 20,
                  ),
                )
              : CupertinoButton(
                  child: Text(
                    'PokerGO',
                    style: TextStyle(fontSize: 28),
                  ),
                  color: CupertinoColors.activeGreen,
                  onPressed: () async {},
                  padding: EdgeInsets.symmetric(
                    vertical: contentSize.height / 20,
                  ),
                ),
          SizedBox(
            height: getSafeArea(context).height / 7,
          ),
          // Poker2FA mode
          CupertinoButton(
            child: Text(
              'Poker2FA',
              style: TextStyle(fontSize: 28),
            ),
            color: CupertinoColors.activeGreen,
            onPressed: () async {
              if (!setting.isDesktop) {
                var qrNavFunc = () async {
                  BotToast.showLoading(
                    crossPage: false,
                    animationDuration: Duration(milliseconds: 200),
                    animationReverseDuration: Duration(milliseconds: 200),
                    backButtonBehavior: BackButtonBehavior.none,
                    backgroundColor: CupertinoDynamicColor.resolve(
                        setting.loadingColor, context),
                    duration: Duration(milliseconds: 800),
                  );
                  Future.delayed(Duration(milliseconds: 200), () async {
                    var result = await Navigator.pushNamed(
                        context, QRCodePage.id,
                        arguments: await scan());
                    if (result is String) BotToast.showText(text: result);
                  });
                };
                if (await Permission.camera.status.isGranted)
                  await qrNavFunc();
                else {
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
                          onPressed: () {
                            Navigator.pop(context);
                            openAppSettings();
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text('啟用'),
                          onPressed: () async {
                            Navigator.pop(context);
                            if (await Permission.camera.request().isGranted)
                              await qrNavFunc();
                          },
                        ),
                      ],
                    ),
                  );
                }
              } else {
                BotToast.showLoading(
                  crossPage: false,
                  animationDuration: Duration(milliseconds: 100),
                  animationReverseDuration: Duration(milliseconds: 100),
                  backButtonBehavior: BackButtonBehavior.none,
                  backgroundColor: CupertinoDynamicColor.resolve(
                      setting.loadingColor, context),
                  duration: Duration(milliseconds: 400),
                );
                Future.delayed(Duration(milliseconds: 200), () async {
                  var result =
                      await Navigator.pushNamed(context, QRCodePage.id);
                  if (result is String) BotToast.showText(text: result);
                });
              }
            },
            padding: EdgeInsets.symmetric(
              vertical: contentSize.height / 20,
            ),
          ),
        ],
      ),
    );
  }

  void scheduleAbsortTouch(final Duration duration) {
    setState(() => isAbsorbTouch = true);
    Future.delayed(duration, () => setState(() => isAbsorbTouch = false));
  }
}

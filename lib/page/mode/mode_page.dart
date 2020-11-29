import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pokerpass/page/mode/PC/pc_page.dart';
import 'package:pokerpass/page/qrcode_page.dart';
import 'package:pokerpass/setting/setting.dart';
import 'package:pokerpass/setting/user.dart';
import 'package:pokerpass/utility/area.dart';
import 'package:pokerpass/utility/argument/qr_argument.dart';
import 'package:pokerpass/utility/utility.dart';
import 'package:qrscan/qrscan.dart';

class ModePage extends StatefulWidget {
  static const id = 'mode_page';
  ModePage({final Key key}) : super(key: key);
  @override
  _ModePageState createState() => _ModePageState();
}

class _ModePageState extends State<ModePage> {
  List<String> userInfo;

  @override
  void initState() {
    super.initState();
    BotToast.showText(text: '已連線');
  }

  @override
  Widget build(final BuildContext context) {
    userInfo = ModalRoute.of(context).settings.arguments;
    return WillPopScope(
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          previousPageTitle: '中斷',
          middle: Text('選擇方式'),
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
                  Utility.loading(Duration(milliseconds: 600), context);
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
          CupertinoButton(
            child: Text(
              '登入',
              style: TextStyle(fontSize: 26),
            ),
            color: CupertinoColors.activeGreen,
            onPressed: Setting.isDesktop
                ? () async {
                    // server number, session id and client number
                    Utility.loading(Duration(milliseconds: 600), context);
                    Future.delayed(Duration(milliseconds: 200), () async {
                      var result =
                          await Navigator.pushNamed(context, PCPage.id);
                      if (result is String) BotToast.showText(text: result);
                    });
                  }
                : () async {
                    if (await UserData.localAuth.canCheckBiometrics) {
                      final isAuthed =
                          await UserData.localAuth.authenticateWithBiometrics(
                        localizedReason: '用生物辨識啟用裝置碼',
                        stickyAuth: true,
                        androidAuthStrings: AndroidAuthMessages(
                          fingerprintHint: '啟用裝置碼',
                          fingerprintRequiredTitle: '需要生物辨識',
                          fingerprintNotRecognized: '辨識失敗',
                          fingerprintSuccess: '成功',
                          cancelButton: '取消',
                          goToSettingsButton: '移至設定',
                          goToSettingsDescription: '生物辨識未設定\n請設定生物辨識功能',
                        ),
                        iOSAuthStrings: IOSAuthMessages(
                          lockOut: '請啟用生物辨識',
                          cancelButton: '取消',
                          goToSettingsButton: '移至設定',
                          goToSettingsDescription: '生物辨識未設定\n請設定生物辨識功能',
                        ),
                      );
                      if (isAuthed) {
                        final deviceKey = await UserData.storage.read(
                            key: '${Setting.deviceKeyName}-${userInfo[0]}');
                        print(deviceKey);
                      }
                    }
                  },
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
              '二階段(${Setting.isDesktop ? '產生' : '掃描'}QRCode)',
              style: TextStyle(fontSize: 26),
            ),
            color: CupertinoColors.activeGreen,
            onPressed: () async {
              if (!Setting.isDesktop) {
                var qrNavFunc = () async {
                  Utility.loading(Duration(milliseconds: 1200), context);
                  var scanResult = await scan();
                  // deal 2FA result into QRArgument
                  var result = await Navigator.pushNamed(context, QRCodePage.id,
                      arguments:
                          QRArgument(ProcessType.TwoFA, url: scanResult));
                  if (result is String) BotToast.showText(text: result);
                };
                if (await Permission.camera.status.isGranted)
                  qrNavFunc();
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
                              qrNavFunc();
                          },
                        ),
                      ],
                    ),
                  );
                }
              } else {
                Utility.loading(Duration(milliseconds: 600), context);
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
}

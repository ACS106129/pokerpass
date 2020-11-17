import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pokerpass/2FA/qrcode_page.dart';
import 'package:pokerpass/PC/pc_page.dart';
import 'package:pokerpass/setting/Setting.dart' as setting;
import 'package:pokerpass/utility/area.dart';
import 'package:qrscan/qrscan.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'login_page';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: '返回',
        middle: Text('選擇登入方式'),
      ),
      child: SafeArea(
        child: Center(
          child: _loginPageContent(context),
        ),
      ),
    );
  }

  Widget _loginPageContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: getSafeArea(context).width * 0.8,
          child: Column(
            children: [
              // PokerPC or PokerGO mode
              setting.isDesktop
                  ? CupertinoButton(
                      onPressed: () {
                        // server number, session id and client number
                        Navigator.pushNamed(context, PCPage.id);
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
                      var result = await scan();
                      Navigator.pushNamed(context, QRCodePage.id,
                          arguments: result);
                    } else {
                      await showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: Text('相機權限要求'),
                          content: Text('該應用需要利用相機進行QRCode掃描'),
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
                  } else
                    Navigator.pushNamed(context, QRCodePage.id);
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

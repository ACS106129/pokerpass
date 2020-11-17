import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerpass/login_page.dart';
import 'package:pokerpass/register_page.dart';
import 'package:pokerpass/setting/Setting.dart' as setting;
import 'package:pokerpass/utility/area.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: !setting.isDesktop
          ? const CupertinoNavigationBar(
              middle: const Text('撲克牌通行碼認證系統'),
            )
          : null,
      child: SafeArea(
        child: Center(
          child: _homePageContent(context),
        ),
      ),
    );
  }

  Widget _homePageContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: getSafeArea(context).width * 0.8,
          child: Column(
            children: [
              CupertinoTextField(
                prefix: Icon(
                  CupertinoIcons.person,
                  color: CupertinoDynamicColor.withBrightness(
                    color: Colors.blue.shade400,
                    darkColor: Colors.blue.shade800,
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter(
                    RegExp(r'^[A-Za-z0-9]{0,20}'),
                    allow: true,
                  ),
                ],
                cursorColor: Colors.blue.shade200,
                placeholder: '請輸入用戶名(ID)',
                autofocus: false,
                maxLines: 1,
              ),
            ],
          ),
        ),
        SizedBox(
          height: getSafeArea(context).height / 10,
        ),
        CupertinoButton(
          onPressed: () {
            Navigator.pushNamed(context, LoginPage.id);
          },
          child: Text(
            '登入',
            style: TextStyle(fontSize: 36),
          ),
          color: Colors.blue,
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
            vertical: 20,
          ),
        ),
        SizedBox(
          height: getSafeArea(context).height / 10,
        ),
        CupertinoButton(
          onPressed: () {
            Navigator.pushNamed(context, RegisterPage.id);
          },
          child: Text(
            '註冊',
            style: TextStyle(fontSize: 36),
          ),
          color: Colors.yellow,
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
            vertical: 20,
          ),
        ),
      ],
    );
  }
}

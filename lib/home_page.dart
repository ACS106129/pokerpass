import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerpass/login_page.dart';
import 'package:pokerpass/register_page.dart';
import 'package:pokerpass/setting/Setting.dart' as setting;

class HomePage extends StatefulWidget {
  final String title;
  HomePage({Key key, this.title}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: !setting.isDesktop
          ? CupertinoNavigationBar(
              middle: const Text('撲克牌通行碼認證系統'),
            )
          : null,
      child: Center(
        child: _homePageContent(context),
      ),
    );
  }

  Widget _homePageContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
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
          height: MediaQuery.of(context).size.height / 10,
        ),
        CupertinoButton(
          onPressed: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => LoginPage(),
                  settings: RouteSettings(name: '/login_page')
                ));},
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
          height: MediaQuery.of(context).size.height / 10,
        ),
        CupertinoButton(
          onPressed: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => RegisterPage(),
                  settings: RouteSettings(name: '/register_page')
                ));
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

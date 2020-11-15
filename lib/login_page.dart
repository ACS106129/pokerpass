import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerpass/setting/Setting.dart' as setting;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: '返回',
      ),
      child: Center(
        child: _loginPageContent(context),
      ),
    );
  }

  Widget _loginPageContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            children: [
              Text('選擇登入方式', style: TextStyle(fontSize: 40)),
              SizedBox(
                height: MediaQuery.of(context).size.height / 15,
              ),
              setting.isDesktop
                  ? CupertinoButton(
                      onPressed: () {},
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
                  : SizedBox.shrink(),
              SizedBox(
                height: MediaQuery.of(context).size.height / 15,
              ),
              CupertinoButton(
                onPressed: () {},
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
              SizedBox(
                height: MediaQuery.of(context).size.height / 15,
              ),
              !setting.isDesktop
                  ? CupertinoButton(
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
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }
}

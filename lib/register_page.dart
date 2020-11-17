import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerpass/utility/area.dart';

class RegisterPage extends StatefulWidget {
  static const String id = 'register_page';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: '返回',
        middle: Text('註冊'),
      ),
      child: SafeArea(
        child: Center(
          child: _registerPageContent(context),
        ),
      ),
    );
  }

  Widget _registerPageContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: getSafeArea(context).width * 0.8,
          child: Column(
            children: [
              CupertinoTextField(
                prefix: Text('用戶名:'),
                inputFormatters: [
                  FilteringTextInputFormatter(
                    RegExp(r'^[A-Za-z0-9]{0,20}'),
                    allow: true,
                  ),
                ],
              ),
              SizedBox(
                height: getSafeArea(context).height / 15,
              ),
              CupertinoTextField(
                obscureText: true,
                prefix: Text('通行碼:'),
                inputFormatters: [
                  FilteringTextInputFormatter(
                    RegExp(r'^[A-Za-z0-9]{0,20}'),
                    allow: true,
                  ),
                ],
              ),
              SizedBox(
                height: getSafeArea(context).height / 15,
              ),
              CupertinoButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  '送出',
                  style: TextStyle(fontSize: 20),
                ),
                color: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
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

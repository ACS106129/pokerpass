import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerpass/page/mode_page.dart';
import 'package:pokerpass/page/register_page.dart';
import 'package:pokerpass/page/setting_page.dart';
import 'package:pokerpass/setting/setting.dart' as setting;
import 'package:pokerpass/setting/user.dart';

class HomePage extends StatefulWidget {
  static const id = '/';
  HomePage({final Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final iconColor = CupertinoDynamicColor.withBrightness(
    color: Colors.blue.shade600,
    darkColor: Colors.blue.shade300,
  );
  final placeholderColor = CupertinoDynamicColor.withBrightness(
      color: CupertinoColors.placeholderText, darkColor: Colors.white70);
  final urlController = TextEditingController(text: UserCache.homeURLText);
  final userController = TextEditingController(text: UserCache.homeUserText);
  final urlFocusNode = FocusNode();
  final userFocusNode = FocusNode();
  Color userColor;

  @override
  void initState() {
    super.initState();
    userFocusNode.addListener(() {
      if (userFocusNode.hasFocus) {
        setState(() {
          userColor = CupertinoDynamicColor.resolve(iconColor, context);
        });
      } else {
        setState(() {
          userColor = CupertinoColors.placeholderText;
        });
      }
    });
  }

  @override
  void dispose() {
    urlFocusNode.dispose();
    userFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    userColor = CupertinoColors.placeholderText;
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: const Text('撲克牌通行碼認證系統'),
      ),
      child: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) => homePageContent(
                context, Size(constraints.maxWidth, constraints.maxHeight)),
          ),
        ),
      ),
    );
  }

  Widget homePageContent(final BuildContext context, final Size contentSize) {
    return Container(
      width: contentSize.width * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              cupertinoTextField(
                  setting.urlLabel,
                  '目標網址(URL)',
                  CupertinoIcons.cloud,
                  TextInputAction.next,
                  setting.urlInputRegex,
                  urlFocusNode),
              SizedBox(height: contentSize.height / 15),
              cupertinoTextField(
                  setting.userLabel,
                  '用戶名(8~20字元)',
                  CupertinoIcons.person,
                  TextInputAction.done,
                  setting.userInputRegex,
                  userFocusNode),
            ],
          ),
          SizedBox(height: contentSize.height / 10),
          CupertinoButton(
            onPressed: () async {
              if (!setting.urlRegex.hasMatch(UserCache.homeURLText)) {
                BotToast.showText(text: '網址格式錯誤!');
                return;
              }
              if (!setting.userRegex.hasMatch(UserCache.homeUserText)) {
                BotToast.showText(text: '使用者格式錯誤!');
                return;
              }
              // request url connect async value
              BotToast.showLoading(
                allowClick: true,
                backButtonBehavior: BackButtonBehavior.close,
                animationDuration: Duration(milliseconds: 200),
                animationReverseDuration: Duration(milliseconds: 200),
                duration: Duration(milliseconds: 800),
                onClose: () => WidgetsBinding.instance.addPostFrameCallback(
                  (_) async {
                    // await login complete and get value
                    Navigator.pushNamed(context, ModePage.id);
                  },
                ),
              );
            },
            child: const Text('登入'),
            color: CupertinoDynamicColor.withBrightness(
              color: Colors.blue.shade600,
              darkColor: Colors.blue.shade300,
            ),
            padding: EdgeInsets.symmetric(
              vertical: contentSize.width / 30,
            ),
          ),
          SizedBox(height: contentSize.height / 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                onPressed: () {
                  Navigator.pushNamed(context, SettingPage.id);
                },
                child: const Text('設定'),
                color: CupertinoDynamicColor.withBrightness(
                  color: Colors.yellow.shade600,
                  darkColor: Colors.yellow.shade300,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: contentSize.width / 10,
                  vertical: contentSize.width / 30,
                ),
              ),
              SizedBox(width: contentSize.width / 20),
              CupertinoButton(
                onPressed: () {
                  Navigator.pushNamed(context, RegisterPage.id);
                },
                child: const Text('註冊'),
                color: CupertinoDynamicColor.withBrightness(
                  color: Colors.black54,
                  darkColor: Colors.white70,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: contentSize.width / 10,
                  vertical: contentSize.width / 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  CupertinoTextField cupertinoTextField(
      final String label,
      final String placeholder,
      final IconData icon,
      final TextInputAction inputAction,
      final RegExp inputRegExp,
      final FocusNode node) {
    return CupertinoTextField(
      cursorColor: CupertinoDynamicColor.resolve(iconColor, context),
      decoration: BoxDecoration(
        border: Border.all(
          color: CupertinoColors.placeholderText,
        ),
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      focusNode: node,
      prefix: Icon(
        icon,
        semanticLabel: label,
        color: CupertinoDynamicColor.resolve(iconColor, context),
      ),
      inputFormatters: [
        FilteringTextInputFormatter(
          inputRegExp,
          allow: true,
        ),
      ],
      maxLines: 1,
      onTap: () {
        // focus change border color
      },
      onChanged: (str) {
        switch (label) {
          case setting.userLabel:
            UserCache.homeUserText = str;
            break;
          case setting.urlLabel:
            UserCache.homeURLText = str;
            break;
          default:
            throw new Exception('Label $str Error!');
        }
      },
      placeholder: placeholder,
      placeholderStyle: TextStyle(
        fontWeight: FontWeight.w400,
        color: CupertinoDynamicColor.resolve(placeholderColor, context),
      ),
      style: TextStyle(
        height: 1.5,
      ),
      textInputAction: inputAction,
    );
  }
}

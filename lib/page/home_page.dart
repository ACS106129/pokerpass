import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerpass/page/mode_page.dart';
import 'package:pokerpass/page/register_page.dart';
import 'package:pokerpass/page/setting_page.dart';
import 'package:pokerpass/setting/Setting.dart' as setting;

class HomePage extends StatefulWidget {
  static const id = 'home_page';
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
  String userText = '';
  String urlText = '';
  FocusNode userPlaceholderFocusNode;
  FocusNode urlPlaceHolderFocusNode;
  Color userPlaceholderColor;

  @override
  void initState() {
    super.initState();
    userPlaceholderFocusNode = FocusNode();
    urlPlaceHolderFocusNode = FocusNode();
    userPlaceholderFocusNode.addListener(() {
      if (userPlaceholderFocusNode.hasFocus) {
        setState(() {
          userPlaceholderColor =
              CupertinoDynamicColor.resolve(iconColor, context);
        });
      } else {
        setState(() {
          userPlaceholderColor = CupertinoColors.placeholderText;
        });
      }
    });
  }

  @override
  void dispose() {
    userPlaceholderFocusNode.dispose();
    urlPlaceHolderFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userPlaceholderColor = CupertinoColors.placeholderText;
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: const Text('撲克牌通行碼認證系統'),
      ),
      child: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) => _homePageContent(
                context, Size(constraints.maxWidth, constraints.maxHeight)),
          ),
        ),
      ),
    );
  }

  Widget _homePageContent(final BuildContext context, final Size contentSize) {
    return Container(
      width: contentSize.width * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              _cupertinoTextField(
                  setting.urlLabel,
                  '目標網址(URL)',
                  CupertinoIcons.cloud,
                  TextInputAction.next,
                  setting.urlInputRegex,
                  urlPlaceHolderFocusNode),
              SizedBox(
                height: contentSize.height / 15,
              ),
              _cupertinoTextField(
                  setting.userLabel,
                  '用戶名(8~20字元)',
                  CupertinoIcons.person,
                  TextInputAction.done,
                  setting.userInputRegex,
                  userPlaceholderFocusNode),
            ],
          ),
          SizedBox(
            height: contentSize.height / 10,
          ),
          CupertinoButton(
            onPressed: () {
              if (!setting.urlRegex.hasMatch(urlText)) {
                BotToast.showText(text: '網址格式錯誤!');
                return;
              }
              if (!setting.userRegex.hasMatch(userText)) {
                BotToast.showText(text: '使用者格式錯誤!');
                return;
              }
              BotToast.showLoading();
              Navigator.pushNamed(context, ModePage.id);
            },
            child: Text('登入'),
            color: CupertinoDynamicColor.withBrightness(
              color: Colors.blue.shade600,
              darkColor: Colors.blue.shade300,
            ),
            padding: EdgeInsets.symmetric(
              vertical: contentSize.width / 30,
            ),
          ),
          SizedBox(
            height: contentSize.height / 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                onPressed: () {
                  Navigator.pushNamed(context, SettingPage.id);
                },
                child: Text('設定'),
                color: CupertinoDynamicColor.withBrightness(
                  color: Colors.yellow.shade600,
                  darkColor: Colors.yellow.shade300,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: contentSize.width / 10,
                  vertical: contentSize.width / 30,
                ),
              ),
              SizedBox(
                width: contentSize.width / 20,
              ),
              CupertinoButton(
                onPressed: () {
                  Navigator.pushNamed(context, RegisterPage.id);
                },
                child: Text('註冊'),
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

  CupertinoTextField _cupertinoTextField(
      final String label,
      final String placeholder,
      final IconData icon,
      final TextInputAction inputAction,
      final RegExp regExp,
      final FocusNode node) {
    return CupertinoTextField(
      autofocus: false,
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
          regExp,
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
            userText = str;
            break;
          case setting.urlLabel:
            urlText = str;
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

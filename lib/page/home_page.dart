import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerpass/page/mode_page.dart';
import 'package:pokerpass/page/register_page.dart';
import 'package:pokerpass/page/setting_page.dart';
import 'package:pokerpass/setting/setting.dart' as setting;

class HomePage extends StatefulWidget {
  static const id = '/';
  HomePage({final Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final urlController = TextEditingController(text: urlText);
  final userController = TextEditingController(text: userText);
  final urlFocusNode = FocusNode();
  final userFocusNode = FocusNode();
  static var urlText = '';
  static var userText = '';
  Color userColor;

  @override
  void initState() {
    super.initState();
    userColor = CupertinoColors.placeholderText;
    userFocusNode.addListener(() {
      if (userFocusNode.hasFocus) {
        setState(() {
          userColor = CupertinoDynamicColor.resolve(setting.iconColor, context);
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
    urlController.dispose();
    userController.dispose();
    urlFocusNode.dispose();
    userFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return WillPopScope(
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: const Text('PokerPass'),
        ),
        child: SafeArea(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) => homePageContent(
                  context, Size(constraints.maxWidth, constraints.maxHeight)),
            ),
          ),
        ),
      ),
      onWillPop: () async {
        await showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            content: const Text('結束程式?'),
            actions: [
              CupertinoDialogAction(
                child: const Text('取消'),
                onPressed: () => Navigator.pop(context),
              ),
              CupertinoDialogAction(
                child: const Text('結束'),
                onPressed: () {
                  Navigator.pop(context);
                  // exit with return 0
                  Navigator.pop(context, 0);
                },
              ),
            ],
          ),
        );
        return false;
      },
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
            child: const Text('建立Session連線'),
            color: CupertinoDynamicColor.withBrightness(
              color: Colors.blue.shade600,
              darkColor: Colors.blue.shade300,
            ),
            onPressed: () async {
              if (!setting.urlRegex.hasMatch(urlController.text)) {
                BotToast.showText(text: '網址格式錯誤!');
                return;
              }
              if (!setting.userRegex.hasMatch(userController.text)) {
                BotToast.showText(text: '使用者格式錯誤!');
                return;
              }
              // request url connect async value
              BotToast.showLoading(
                animationDuration: Duration(milliseconds: 200),
                animationReverseDuration: Duration(milliseconds: 200),
                backButtonBehavior: BackButtonBehavior.none,
                backgroundColor: CupertinoDynamicColor.resolve(
                    setting.loadingColor, context),
                duration: Duration(milliseconds: 800),
                onClose: () => WidgetsBinding.instance.addPostFrameCallback(
                  (_) async {
                    // await login complete and get value
                    var result = await updateAndPush(context, ModePage.id);
                    if (result is String) BotToast.showText(text: result);
                  },
                ),
              );
            },
            padding: EdgeInsets.symmetric(
              vertical: contentSize.width / 30,
            ),
          ),
          SizedBox(height: contentSize.height / 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                child: const Text('設定'),
                color: CupertinoDynamicColor.withBrightness(
                  color: Colors.yellow.shade600,
                  darkColor: Colors.yellow.shade300,
                ),
                onPressed: () async {
                  var result = await updateAndPush(context, SettingPage.id);
                  if (result is String) BotToast.showText(text: result);
                },
                padding: EdgeInsets.symmetric(
                  horizontal: contentSize.width / 10,
                  vertical: contentSize.width / 30,
                ),
              ),
              SizedBox(width: contentSize.width / 20),
              CupertinoButton(
                child: const Text('註冊'),
                color: CupertinoDynamicColor.withBrightness(
                  color: Colors.black54,
                  darkColor: Colors.white70,
                ),
                onPressed: () async {
                  var result = await updateAndPush(context, RegisterPage.id);
                  if (result is List && result.length >= 2) {
                    urlController.text = result.first ?? '';
                    userController.text = result.elementAt(1) ?? '';
                  }
                },
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

  // update current state and push to next route
  Future<Object> updateAndPush(final BuildContext context, final String toId,
      {Object arguments}) async {
    urlText = urlController.text;
    userText = userController.text;
    urlFocusNode.unfocus();
    userFocusNode.unfocus();
    return Navigator.pushNamed(context, toId, arguments: arguments);
  }

  CupertinoTextField cupertinoTextField(
      final String label,
      final String placeholder,
      final IconData icon,
      final TextInputAction inputAction,
      final RegExp inputRegExp,
      final FocusNode node) {
    return CupertinoTextField(
      controller: (() {
        switch (label) {
          case setting.urlLabel:
            return urlController;
          case setting.userLabel:
            return userController;
          default:
            throw new Exception('Label $label Error!');
        }
      })(),
      cursorColor: CupertinoDynamicColor.resolve(setting.iconColor, context),
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
        color: CupertinoDynamicColor.resolve(setting.iconColor, context),
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
      placeholder: placeholder,
      placeholderStyle: TextStyle(
        fontWeight: FontWeight.w400,
        color: CupertinoDynamicColor.resolve(setting.placeholderColor, context),
      ),
      style: TextStyle(
        height: 1.5,
      ),
      textInputAction: inputAction,
    );
  }
}

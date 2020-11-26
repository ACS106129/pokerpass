import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerpass/setting/user.dart';
import 'package:pokerpass/page/Setting_page.dart';
import 'package:pokerpass/page/mode/mode_page.dart';
import 'package:pokerpass/page/register/register_page.dart';
import 'package:pokerpass/setting/setting.dart';
import 'package:pokerpass/utility/utility.dart';

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

  @override
  void initState() {
    super.initState();
    // load user data from storage
    UserData.usePrefs((prefs) {
      UserData.isSystemThemeMode =
          prefs.get(Setting.systemThemeModeName) ?? true;
      final isDarkThemeMode = prefs.get(Setting.darkThemeModeName) ?? null;
      if (!UserData.isSystemThemeMode && isDarkThemeMode is bool)
        UserData.brightness
            .add(isDarkThemeMode ? Brightness.dark : Brightness.light);
    });
    // add platform brightness changed listener
    WidgetsBinding.instance.window.onPlatformBrightnessChanged = () {
      Config.platformBrightness = window.platformBrightness;
      if (UserData.isSystemThemeMode)
        UserData.brightness.add(window.platformBrightness);
    };
  }

  @override
  void dispose() {
    // save user data into storage
    UserData.usePrefs((prefs) {
      prefs.setBool(Setting.systemThemeModeName, UserData.isSystemThemeMode);
      prefs.setBool(
          Setting.darkThemeModeName, UserData.snapshot.data == Brightness.dark);
    });
    // dispose here
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
        children: [
          Column(
            children: [
              cupertinoTextField(
                  Setting.urlLabel,
                  '目標網址(URL)',
                  CupertinoIcons.cloud,
                  TextInputAction.next,
                  Setting.urlInputRegex,
                  urlFocusNode),
              SizedBox(height: contentSize.height / 15),
              cupertinoTextField(
                  Setting.userLabel,
                  '用戶名(8~20字元)',
                  CupertinoIcons.person,
                  TextInputAction.done,
                  Setting.userInputRegex,
                  userFocusNode),
            ],
          ),
          SizedBox(height: contentSize.height / 10),
          CupertinoButton(
            child: const Text('建立Session連線'),
            color: Setting.iconColor,
            onPressed: () async {
              if (!Setting.urlRegex.hasMatch(urlController.text)) {
                BotToast.showText(text: '網址格式錯誤!');
                return;
              }
              if (!Setting.userRegex.hasMatch(userController.text)) {
                BotToast.showText(text: '使用者格式錯誤!');
                return;
              }
              Utility.loading(Duration(milliseconds: 1200), context);
              // await request url connect value
              Future.delayed(Duration(milliseconds: 400), () async {
                // await login complete and get value
                var result = await updateAndPush(context, ModePage.id);
                if (result is String) BotToast.showText(text: result);
              });
            },
            padding: EdgeInsets.symmetric(
              horizontal: contentSize.width / 10,
            ),
          ),
          SizedBox(height: contentSize.height / 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                child: const Text('設定'),
                color: Setting.settingButtonColor,
                onPressed: () async {
                  var result = await updateAndPush(context, SettingPage.id);
                  if (result is String) BotToast.showText(text: result);
                },
                padding: EdgeInsets.symmetric(
                  horizontal: contentSize.width / 15,
                ),
              ),
              SizedBox(width: contentSize.width / 10),
              CupertinoButton(
                child: const Text('註冊'),
                color: Setting.registerButtonColor,
                onPressed: () async {
                  var result = await updateAndPush(context, RegisterPage.id);
                  if (result is List && result.length >= 2) {
                    urlController.text = result.first ?? '';
                    userController.text = result.elementAt(1) ?? '';
                  }
                },
                padding: EdgeInsets.symmetric(
                  horizontal: contentSize.width / 15,
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
          case Setting.urlLabel:
            return urlController;
          case Setting.userLabel:
            return userController;
          default:
            throw ArgumentError('Label:$label Error!');
        }
      })(),
      cursorColor: CupertinoDynamicColor.resolve(Setting.iconColor, context),
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
        color: CupertinoDynamicColor.resolve(Setting.iconColor, context),
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
        color: CupertinoDynamicColor.resolve(Setting.placeholderColor, context),
      ),
      style: TextStyle(
        height: 1.5,
      ),
      textInputAction: inputAction,
    );
  }
}

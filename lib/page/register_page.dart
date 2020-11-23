import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:pokerpass/setting/setting.dart' as setting;

class RegisterPage extends StatefulWidget {
  static const id = 'register_page';
  RegisterPage({final Key key}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final urlController = TextEditingController(text: urlText);
  final userController = TextEditingController(text: userText);
  final passwordController = TextEditingController(text: '');
  final urlFocusNode = FocusNode(debugLabel: setting.urlLabel);
  final userFocusNode = FocusNode(debugLabel: setting.userLabel);
  final passwordFocusNode = FocusNode(debugLabel: setting.passwordLabel);
  static var urlText = '';
  static var userText = '';

  @override
  void dispose() {
    urlText = urlController.text;
    urlController.dispose();
    userController.dispose();
    passwordController.dispose();
    urlFocusNode.dispose();
    userFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return WillPopScope(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          previousPageTitle: '返回',
          middle: const Text('註冊'),
          trailing: GestureDetector(
            child: Text(
              '送出',
              style: TextStyle(
                color: CupertinoDynamicColor.resolve(
                    CupertinoColors.activeGreen, context),
              ),
            ),
            onTap: () async {
              if (!setting.urlRegex.hasMatch(urlController.text)) {
                BotToast.showText(text: '網址格式錯誤');
                return;
              }
              if (!setting.userRegex.hasMatch(userController.text)) {
                BotToast.showText(text: '使用者格式錯誤');
                return;
              }
              if (!setting.passwordRegex.hasMatch(passwordController.text)) {
                BotToast.showText(text: '通行碼格式錯誤');
                return;
              }
              // cancel keyboard input
              urlFocusNode.unfocus();
              userFocusNode.unfocus();
              passwordFocusNode.unfocus();
              BotToast.showLoading(
                animationDuration: Duration(milliseconds: 250),
                animationReverseDuration: Duration(milliseconds: 250),
                backButtonBehavior: BackButtonBehavior.none,
                backgroundColor: CupertinoDynamicColor.resolve(
                    setting.loadingColor, context),
                duration: Duration(milliseconds: 700),
                onClose: () => SchedulerBinding.instance.addPostFrameCallback(
                  (_) async {
                    // await submit complete and get value

                    // save devices key in device

                    // erase register user id
                    userText = '';
                    // give url and user id to login
                    Navigator.pop(
                        context, [urlController.text, userController.text]);
                  },
                ),
              );
              // submit user id and password to server through url to get devices key
            },
          ),
        ),
        child: SafeArea(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) => registerPageContent(
                  context, Size(constraints.maxWidth, constraints.maxHeight)),
            ),
          ),
        ),
      ),
      onWillPop: () async {
        // save user id to register cache
        userText = userController.text;
        return true;
      },
    );
  }

  Widget registerPageContent(
      final BuildContext context, final Size contentSize) {
    return Container(
      width: contentSize.width * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          cupertinoTextField(setting.urlLabel, '(URL名稱)', '[註冊網址]',
              TextInputAction.next, setting.urlInputRegex, urlFocusNode),
          SizedBox(height: contentSize.height / 15),
          cupertinoTextField(setting.userLabel, '(8~20字元)', '[用戶名]',
              TextInputAction.next, setting.userInputRegex, userFocusNode),
          SizedBox(height: contentSize.height / 15),
          cupertinoTextField(
              setting.passwordLabel,
              '(8~15字元)',
              '[通行碼]',
              TextInputAction.done,
              setting.passwordInputRegex,
              passwordFocusNode),
          SizedBox(height: contentSize.height / 5),
          CupertinoButton(
            child: const Text('清除全部'),
            color: CupertinoDynamicColor.withBrightness(
              color: Colors.black54,
              darkColor: Colors.white70,
            ),
            onPressed: () {
              urlController.clear();
              userController.clear();
              passwordController.clear();
            },
            padding: EdgeInsets.symmetric(
              horizontal: contentSize.width / 20,
            ),
          ),
        ],
      ),
    );
  }

  CupertinoTextField cupertinoTextField(
      final String label,
      final String placeholder,
      final String prompt,
      final TextInputAction inputAction,
      final RegExp inputRegExp,
      final FocusNode node) {
    return CupertinoTextField(
      clearButtonMode: OverlayVisibilityMode.editing,
      controller: (() {
        switch (label) {
          case setting.urlLabel:
            return urlController;
          case setting.userLabel:
            return userController;
          case setting.passwordLabel:
            return passwordController;
          default:
            throw new Exception('Label $label Error!');
        }
      })(),
      decoration: BoxDecoration(
        border: Border.all(
          color: CupertinoColors.placeholderText,
        ),
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      focusNode: node,
      inputFormatters: [
        FilteringTextInputFormatter(
          inputRegExp,
          allow: true,
        ),
      ],
      maxLines: 1,
      obscureText: label == setting.passwordLabel,
      onTap: () {
        // focus change border color
      },
      prefix: Text(
        prompt,
        style: TextStyle(
          color:
              CupertinoDynamicColor.resolve(setting.promptTextColor, context),
        ),
      ),
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

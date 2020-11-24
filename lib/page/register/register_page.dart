import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pokerpass/page/qrcode_page.dart';
import 'package:pokerpass/setting/setting.dart';
import 'package:pokerpass/setting/user.dart';
import 'package:pokerpass/utility/argument/qr_argument.dart';
import 'package:pokerpass/utility/utility.dart';
import 'package:qrscan/qrscan.dart';

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
  final urlFocusNode = FocusNode(debugLabel: Setting.urlLabel);
  final userFocusNode = FocusNode(debugLabel: Setting.userLabel);
  final passwordFocusNode = FocusNode(debugLabel: Setting.passwordLabel);
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
          cupertinoTextField(Setting.urlLabel, '(URL名稱)', '[註冊網址]',
              TextInputAction.next, Setting.urlInputRegex, urlFocusNode),
          SizedBox(height: contentSize.height / 15),
          cupertinoTextField(Setting.userLabel, '(8~20字元)', '[用戶名]',
              TextInputAction.next, Setting.userInputRegex, userFocusNode),
          SizedBox(height: contentSize.height / 15),
          cupertinoTextField(
              Setting.passwordLabel,
              '(8~15字元)',
              '[通行碼]',
              TextInputAction.done,
              Setting.passwordInputRegex,
              passwordFocusNode),
          SizedBox(height: contentSize.height / 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                child: const Text('送出'),
                color: Setting.submitButtonColor,
                onPressed: () {
                  if (!Setting.urlRegex.hasMatch(urlController.text)) {
                    BotToast.showText(text: '網址格式錯誤');
                    return;
                  }
                  if (!Setting.userRegex.hasMatch(userController.text)) {
                    BotToast.showText(text: '使用者格式錯誤');
                    return;
                  }
                  if (!Setting.passwordRegex
                      .hasMatch(passwordController.text)) {
                    BotToast.showText(text: '通行碼格式錯誤');
                    return;
                  }
                  // cancel keyboard input
                  urlFocusNode.unfocus();
                  userFocusNode.unfocus();
                  passwordFocusNode.unfocus();
                  Utility.loading(Duration(milliseconds: 1200), context);
                  // submit user id and password to server through url, then get device key and session id
                  final String deviceKey = '123456';
                  final String sessionId = 'abc';
                  Future.delayed(Duration(milliseconds: 350), () async {
                    // save device key in mobile device
                    if (!Setting.isDesktop)
                      await UserData.usePrefs((prefs) =>
                          prefs.setString(Setting.deviceKeyName, deviceKey));
                    else {
                      // generate qrcode to mobile
                      var result =
                          await Navigator.pushNamed(context, QRCodePage.id,
                              arguments: QRArgument(
                                ProcessType.Register,
                                url: urlController.text,
                                user: userController.text,
                                password: passwordController.text,
                                sessionId: sessionId,
                                deviceKey: deviceKey,
                              ));
                      if (result is String) BotToast.showText(text: result);
                    }
                    // erase register user id
                    userText = '';
                    // give url and user id to login
                    Navigator.pop(
                        context, [urlController.text, userController.text]);
                  });
                },
                padding: EdgeInsets.symmetric(
                  horizontal: contentSize.width / 20,
                ),
              ),
              SizedBox(width: contentSize.width / 10),
              CupertinoButton(
                child: const Text('清除'),
                color: Setting.registerButtonColor,
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
          !Setting.isDesktop
              ? Column(
                  children: [
                    SizedBox(height: contentSize.height / 10),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: CupertinoDynamicColor.resolve(
                                Setting.promptTextColor, context),
                          ),
                        ),
                        const Text(' 或 '),
                        Expanded(
                          child: Divider(
                            color: CupertinoDynamicColor.resolve(
                                Setting.promptTextColor, context),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: contentSize.height / 10),
                    CupertinoButton(
                      child: const Text('註冊PC端二階段認證'),
                      color: Setting.connectSessionButtonColor,
                      onPressed: () async {
                        var qrNavFunc = () {
                          Utility.loading(Duration(milliseconds: 1200), context);
                          Future.delayed(Duration(milliseconds: 200), () async {
                            var scanResult = await scan();
                            // deal result into QRArgument
                            var result = await Navigator.pushNamed(
                                context, QRCodePage.id,
                                arguments: QRArgument(ProcessType.Register,
                                    url: scanResult));
                            if (result is String)
                              BotToast.showText(text: result);
                          });
                        };
                        if (await Permission.camera.status.isGranted)
                          qrNavFunc();
                        else {
                          await showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                              title: Text('相機權限要求'),
                              content: Text('該應用需要相機進行QRCode掃描'),
                              actions: [
                                CupertinoDialogAction(
                                  child: Text('取消'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                CupertinoDialogAction(
                                  child: Text('設定'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    openAppSettings();
                                  },
                                ),
                                CupertinoDialogAction(
                                  child: Text('啟用'),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    if (await Permission.camera
                                        .request()
                                        .isGranted) qrNavFunc();
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      padding: EdgeInsets.symmetric(
                        horizontal: contentSize.width / 20,
                      ),
                    )
                  ],
                )
              : SizedBox.shrink(),
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
          case Setting.urlLabel:
            return urlController;
          case Setting.userLabel:
            return userController;
          case Setting.passwordLabel:
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
      obscureText: label == Setting.passwordLabel,
      onTap: () {
        // focus change border color
      },
      prefix: Text(
        prompt,
        style: TextStyle(
          color:
              CupertinoDynamicColor.resolve(Setting.promptTextColor, context),
        ),
      ),
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

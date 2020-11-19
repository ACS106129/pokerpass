import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerpass/setting/setting.dart' as setting;
import 'package:pokerpass/setting/user.dart';

class RegisterPage extends StatefulWidget {
  static const id = 'register_page';
  RegisterPage({final Key key}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final promptTextColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.black,
    darkColor: CupertinoColors.white,
  );
  final loadingColor = CupertinoDynamicColor.withBrightness(
    color: Colors.black26,
    darkColor: Colors.white10,
  );
  final placeholderColor = CupertinoDynamicColor.withBrightness(
      color: CupertinoColors.placeholderText, darkColor: Colors.white70);
  final urlController = TextEditingController(text: UserCache.registerURLText);
  final userController =
      TextEditingController(text: UserCache.registerUserText);
  final passwordController =
      TextEditingController(text: UserCache.registerPasswordText);
  final urlFocusNode = FocusNode(debugLabel: setting.urlLabel);
  final userFocusNode = FocusNode(debugLabel: setting.userLabel);
  final passwordFocusNode = FocusNode(debugLabel: setting.passwordLabel);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    UserCache.registerURLText = urlController.text;
    // password must be clear
    UserCache.registerPasswordText = '';
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        leading: CupertinoNavigationBarBackButton(
          previousPageTitle: '返回',
          onPressed: () async {
            // save user id to register cache
            UserCache.registerUserText = userController.text;
            Navigator.pop(context);
          },
        ),
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
              backgroundColor:
                  CupertinoDynamicColor.resolve(loadingColor, context),
              duration: Duration(milliseconds: 700),
              onClose: () => WidgetsBinding.instance.addPostFrameCallback(
                (_) async {
                  // await submit complete and get value
                  // give user id to login
                  UserCache.homeURLText = urlController.text;
                  UserCache.homeUserText = userController.text;
                  // erase register user id
                  UserCache.registerUserText = '';
                  Navigator.pop(context);
                },
              ),
            );
            // submit user id and password to server through url
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
          color: CupertinoDynamicColor.resolve(promptTextColor, context),
        ),
      ),
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

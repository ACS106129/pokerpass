import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerpass/setting/Setting.dart' as setting;

class RegisterPage extends StatefulWidget {
  static const String id = 'register_page';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final promptTextColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.black,
    darkColor: CupertinoColors.white,
  );
  String userText = '';
  String passwordText = '';
  String urlText = '';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        leading: CupertinoNavigationBarBackButton(
          previousPageTitle: '返回',
          onPressed: () async {
            // ensure users if they want to leave with the field filled

            Navigator.pop(context);
          },
        ),
        middle: Text('註冊'),
        trailing: GestureDetector(
          onTap: () {
            if (!setting.userRegex.hasMatch(userText)) {
              BotToast.showText(text: '使用者格式錯誤');
              return;
            }
            if (!setting.passwordRegex.hasMatch(passwordText)) {
              BotToast.showText(text: '通行碼格式錯誤');
              return;
            }
            if (!setting.urlRegex.hasMatch(urlText)) {
              BotToast.showText(text: '網址格式錯誤');
              return;
            }
            // submit user id and password to server through url
            BotToast.showLoading(
              onClose: () => Navigator.pop(context),
            );
          },
          child: Text(
            '送出',
            style: TextStyle(
              color: CupertinoDynamicColor.resolve(
                  CupertinoColors.activeGreen, context),
            ),
          ),
        ),
      ),
      child: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) => _registerPageContent(
                context, Size(constraints.maxWidth, constraints.maxHeight)),
          ),
        ),
      ),
    );
  }

  Widget _registerPageContent(
      final BuildContext context, final Size contentSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: contentSize.width * 0.7,
          child: Column(
            children: [
              CupertinoTextField(
                prefix: Text(
                  '註冊網址: ',
                  style: TextStyle(
                    color:
                        CupertinoDynamicColor.resolve(promptTextColor, context),
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter(
                    setting.urlInputRegex,
                    allow: true,
                  ),
                ],
                //cursorColor: ,
                autofocus: false,
                maxLines: 1,
                style: TextStyle(
                  height: 1.5,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: CupertinoColors.placeholderText,
                  ),
                  color: CupertinoColors.systemBackground,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                textInputAction: TextInputAction.next,
                onChanged: (str) => urlText = str,
              ),
              SizedBox(
                height: contentSize.height / 15,
              ),
              CupertinoTextField(
                prefix: Text(
                  '用戶名: ',
                  style: TextStyle(
                    color:
                        CupertinoDynamicColor.resolve(promptTextColor, context),
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter(
                    setting.userInputRegex,
                    allow: true,
                  ),
                ],
                autofocus: false,
                maxLines: 1,
                style: TextStyle(
                  height: 1.5,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: CupertinoColors.placeholderText,
                  ),
                  color: CupertinoColors.systemBackground,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                textInputAction: TextInputAction.next,
                onChanged: (str) => userText = str,
              ),
              SizedBox(
                height: contentSize.height / 15,
              ),
              CupertinoTextField(
                obscureText: true,
                prefix: Text(
                  '通行碼: ',
                  style: TextStyle(
                    color:
                        CupertinoDynamicColor.resolve(promptTextColor, context),
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter(
                    setting.passwordInputRegex,
                    allow: true,
                  ),
                ],
                autofocus: false,
                maxLines: 1,
                style: TextStyle(
                  height: 1.5,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: CupertinoColors.placeholderText,
                  ),
                  color: CupertinoColors.systemBackground,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                textInputAction: TextInputAction.done,
                onChanged: (str) => passwordText = str,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:pokerpass/page/finish/finish_page.dart';
import 'package:pokerpass/poker/poker.dart';
import 'package:pokerpass/setting/setting.dart';
import 'package:pokerpass/utility/event/button_events.dart';
import 'package:pokerpass/utility/utility.dart';

class PCPage extends StatefulWidget {
  static const id = 'pc_page';
  PCPage({final Key key}) : super(key: key);
  @override
  _PCPageState createState() => _PCPageState();
}

class _PCPageState extends State<PCPage> {
  final passwordController = TextEditingController(text: '');
  final suitController = TextEditingController(text: '');
  final challengeCodeController = TextEditingController(text: '');
  var contentPageNumber = 1;
  var errorTimes = 0;
  PokerGame pokerGame;

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return WillPopScope(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          previousPageTitle: contentPageNumber == 1 ? '中止' : '上一步',
          middle: Text('PokerPC ($contentPageNumber/3)'),
          trailing: GestureDetector(
            onTap: () {
              if (contentPageNumber == 1) {
                if (!Setting.pokerPCPasswordRegex
                    .hasMatch(passwordController.text)) {
                  BotToast.showText(text: '通行碼輸入格式錯誤');
                  return;
                }
                setState(() => contentPageNumber += 1);
                return;
              } else if (contentPageNumber == 2) {
                if (suitController.text.length < 4) {
                  BotToast.showText(text: '花色輸入格式錯誤');
                  return;
                }
                setState(() => contentPageNumber += 1);
                return;
              } else if (challengeCodeController.text.length < 2) {
                BotToast.showText(text: '挑戰碼輸入格式錯誤');
                return;
              }
              if (pokerGame.firstphase &&
                  pokerGame.challengecheck1 &&
                  pokerGame.challengecheck2)
                // submit result
                Navigator.pushNamed(context, FinishPage.id);
              else {
                BotToast.showText(text: '登入失敗${++errorTimes}次');
                if (errorTimes == 5) Navigator.pop(context, false);
              }
            },
            child: Text(
              contentPageNumber == 3 ? '送出' : '下一步',
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
              builder: (context, constraints) => pcPageContent(
                  context, Size(constraints.maxWidth, constraints.maxHeight)),
            ),
          ),
        ),
      ),
      onWillPop: () async {
        if (contentPageNumber != 1) {
          setState(() => contentPageNumber -= 1);
          return false;
        }
        await showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('警告'),
            content: const Text('中止PokerPC登入?'),
            actions: [
              CupertinoDialogAction(
                child: const Text('取消'),
                onPressed: () => Navigator.pop(context),
              ),
              CupertinoDialogAction(
                child: const Text('中止'),
                onPressed: () {
                  Utility.loading(Duration(milliseconds: 600), context);
                  // await delete server random and client random
                  Future.delayed(Duration(milliseconds: 200), () async {
                    Navigator.pop(context);
                    Navigator.pop(context, '已中止登入');
                  });
                },
              ),
            ],
          ),
        );
        return false;
      },
    );
  }

  Widget pcPageContent(final BuildContext context, final Size contentSize) {
    final phaseTextField = CupertinoTextField(
      controller:
          contentPageNumber == 2 ? suitController : challengeCodeController,
      placeholderStyle: TextStyle(
        fontWeight: FontWeight.w400,
        color: CupertinoDynamicColor.resolve(Setting.placeholderColor, context),
      ),
      style: TextStyle(
        height: 1.5,
      ),
      readOnly: true,
      obscureText: true,
    );
    switch (contentPageNumber) {
      case 1:
        return Container(
          width: contentSize.width * 0.7,
          child: CupertinoTextField(
            controller: passwordController,
            placeholder: '請輸入通行碼前四位',
            placeholderStyle: TextStyle(
              fontWeight: FontWeight.w400,
              color: CupertinoDynamicColor.resolve(
                  Setting.placeholderColor, context),
            ),
            inputFormatters: [
              FilteringTextInputFormatter(
                Setting.pokerPCPasswordInputRegex,
                allow: true,
              ),
            ],
            style: TextStyle(
              height: 1.5,
            ),
            autofocus: true,
            obscureText: true,
          ),
        );
      case 2:
      case 3:
        pokerGame ??= PokerGame(contentSize, Random.secure().nextInt(1 << 32),
            passwordController.text);
        pokerGame.phase = contentPageNumber == 2 ? 1 : 2;
        return Stack(
          alignment: Alignment.topRight,
          children: [
            pokerGame.widget,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    width: 100,
                    child: phaseTextField,
                  ),
                ),
                SizedBox(width: 10),
                cupertinoListenableButton(
                    '輸入', contentSize, Setting.iconColor, phaseTextField),
                SizedBox(width: 10),
                cupertinoListenableButton('清除', contentSize,
                    Setting.registerButtonColor, phaseTextField),
                SizedBox(width: 10),
              ],
            ),
          ],
        );
      default:
        throw ArgumentError('ContentPageNumber:$contentPageNumber error!');
    }
  }

  Widget cupertinoListenableButton(final String label, final Size contentSize,
      final Color color, final CupertinoTextField textField) {
    final globalKey = GlobalKey();
    final button = CupertinoButton(
      key: globalKey,
      child: Text(label),
      color: color,
      onPressed: () {},
      padding: EdgeInsets.symmetric(
        horizontal: contentSize.width / 30,
      ),
    );
    var isPrimaryPress = false;
    return Listener(
      child: button,
      onPointerDown: (event) {
        if (event.buttons == kPrimaryMouseButton) {
          if (label == '輸入') {
            if (textField.controller.text.length < 11)
              textField.controller.text += ' ';
            else
              BotToast.showText(text: '輸入已達上限');
          }
          pokerGame
              .onButtonEvent(ButtonEvent(button, label, ButtonState.Press));
          isPrimaryPress = true;
        }
      },
      onPointerHover: (event) {
        pokerGame.onButtonEvent(ButtonEvent(button, label, ButtonState.Hover));
      },
      onPointerUp: (event) {
        if (!isPrimaryPress) return;
        if (globalKey.currentContext.size.contains(event.localPosition)) {
          pokerGame
              .onButtonEvent(ButtonEvent(button, label, ButtonState.Release));
          if (label == '清除') textField.controller.clear();
        }
        isPrimaryPress = false;
      },
    );
  }
}

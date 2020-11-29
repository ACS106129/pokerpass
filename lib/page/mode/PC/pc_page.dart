
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:pokerpass/poker/poker.dart';
import 'package:pokerpass/setting/setting.dart';
import 'package:pokerpass/utility/utility.dart';

class PCPage extends StatefulWidget {
  static const id = 'pc_page';
  PCPage({final Key key}) : super(key: key);
  @override
  _PCPageState createState() => _PCPageState();
}

class _PCPageState extends State<PCPage> {
  final passwordController = TextEditingController(text: '');
  var contentPageNumber = 1;

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
          middle: Text('PokerPC ($contentPageNumber/2)'),
          trailing: GestureDetector(
            onTap: () {
              if (contentPageNumber == 1) {
                if (!Setting.pokerPCPasswordRegex
                    .hasMatch(passwordController.text)) {
                  BotToast.showText(text: '通行碼格式錯誤');
                  return;
                }
                setState(() => contentPageNumber += 1);
                return;
              }
              // submit result
            },
            child: Text(
              contentPageNumber == 1 ? '下一步' : '送出',
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
            style: TextStyle(
              height: 1.5,
            ),
            maxLength: 4,
            autofocus: true,
            obscureText: true,
          ),
        );
      case 2:
        return PokerGame(contentSize, 153643).widget;
      default:
        throw ArgumentError('ContentPageNumber:$contentPageNumber error!');
    }
  }
}

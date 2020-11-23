import 'package:flutter/cupertino.dart';
import 'package:pokerpass/poker/poker.dart';

class PCPage extends StatefulWidget {
  static const id = 'pc_page';
  PCPage({final Key key}) : super(key: key);
  @override
  _PCPageState createState() => _PCPageState();
}

class _PCPageState extends State<PCPage> {
  @override
  Widget build(final BuildContext context) {
    return WillPopScope(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          previousPageTitle: '中止',
          middle: const Text('PokerPC'),
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
                  // delete server random and client random
                  Navigator.pop(context);
                  Navigator.pop(context, '已中止登入');
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
    return PokerGame(contentSize).widget;
  }
}

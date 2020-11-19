import 'package:flutter/cupertino.dart';
import 'package:pokerpass/page/mode_page.dart';
import 'package:pokerpass/poker/poker.dart';

class PCPage extends StatefulWidget {
  static const String id = 'pc_page';
  PCPage({Key key}) : super(key: key);
  @override
  _PCPageState createState() => _PCPageState();
}

class _PCPageState extends State<PCPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        leading: CupertinoNavigationBarBackButton(
          previousPageTitle: '中止',
          // delete server random, session id and client random
          onPressed: () async {
            await showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: const Text('警告'),
                content: const Text('確定要中止PokerPC模式?'),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('取消'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoDialogAction(
                    child: const Text('中止'),
                    onPressed: () => Navigator.popUntil(
                        context, ModalRoute.withName(ModePage.id)),
                  ),
                ],
              ),
            );
          },
        ),
        middle: const Text('PokerPC'),
      ),
      child: SafeArea(
        child: _pcPageContent(context),
      ),
    );
  }

  Widget _pcPageContent(final BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) =>
          PokerGame(Size(constraints.maxWidth, constraints.maxHeight)).widget,
    );
  }
}

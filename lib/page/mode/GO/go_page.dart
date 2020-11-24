import 'package:flutter/cupertino.dart';

class GOPage extends StatefulWidget {
  static const id = 'go_page';
  GOPage({final Key key}) : super(key: key);
  @override
  _GOPageState createState() => _GOPageState();
}

class _GOPageState extends State<GOPage> {
  @override
  Widget build(final BuildContext context) {
    return WillPopScope(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          previousPageTitle: '中止',
          middle: const Text('PokerGO'),
        ),
        child: SafeArea(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) => goPageContent(
                  context, Size(constraints.maxWidth, constraints.maxHeight)),
            ),
          ),
        ),
      ),
      onWillPop: () async {
        return true;
      },
    );
  }

  Widget goPageContent(
      final BuildContext context, final Size contentSize) {
    return Container(
      width: contentSize.width * 0.7,
      child: Column(
        children: [],
      ),
    );
  }
}

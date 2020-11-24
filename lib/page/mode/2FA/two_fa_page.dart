import 'package:flutter/cupertino.dart';

class TwoFAPage extends StatefulWidget {
  static const id = 'twoFA_page';
  TwoFAPage({final Key key}) : super(key: key);
  @override
  _TwoFAPageState createState() => _TwoFAPageState();
}

class _TwoFAPageState extends State<TwoFAPage> {
  @override
  Widget build(final BuildContext context) {
    return WillPopScope(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          previousPageTitle: '中止',
          middle: const Text('Poker2FA'),
        ),
        child: SafeArea(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) => twoFAPageContent(
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

  Widget twoFAPageContent(final BuildContext context, final Size contentSize) {
    return Container(
      width: contentSize.width * 0.7,
      child: Column(
        children: [],
      ),
    );
  }
}

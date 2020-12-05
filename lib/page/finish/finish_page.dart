import 'package:flutter/cupertino.dart';
import 'package:pokerpass/setting/setting.dart';

class FinishPage extends StatefulWidget {
  static const id = 'finish_page';
  FinishPage({final Key key}) : super(key: key);
  @override
  _FinishPageState createState() => _FinishPageState();
}

class _FinishPageState extends State<FinishPage> {
  @override
  Widget build(final BuildContext context) {
    return WillPopScope(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('會員'),
        ),
        child: SafeArea(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) => finishPageContent(
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

  Widget finishPageContent(final BuildContext context, final Size contentSize) {
    return Container(
      width: contentSize.width * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '已登入完成!',
            style: TextStyle(
                color: CupertinoDynamicColor.resolve(
                    Setting.promptTextColor, context),
                fontSize: 32),
          ),
        ],
      ),
    );
  }
}

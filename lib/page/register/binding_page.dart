import 'package:flutter/cupertino.dart';

class BindingPage extends StatefulWidget {
  static const id = 'binding_page';
  BindingPage({final Key key}) : super(key: key);
  @override
  _BindingPageState createState() => _BindingPageState();
}

class _BindingPageState extends State<BindingPage> {
  @override
  Widget build(final BuildContext context) {
    return WillPopScope(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          previousPageTitle: '返回',
          middle: const Text('綁定項目'),
        ),
        child: SafeArea(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) => bindingPageContent(
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

  Widget bindingPageContent(
      final BuildContext context, final Size contentSize) {
    return Container(
      width: contentSize.width * 0.7,
      child: Column(
        children: [],
      ),
    );
  }
}

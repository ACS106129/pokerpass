import 'package:flutter/cupertino.dart';

class SettingPage extends StatefulWidget {
  static const id = 'setting_page';
  SettingPage({final Key key}) : super(key: key);
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(final BuildContext context) {
    return WillPopScope(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          previousPageTitle: '取消',
          middle: const Text('設定'),
          trailing: GestureDetector(
            onTap: () {
              // finish user configuration
              Navigator.pop(context);
            },
            child: Text(
              '完成',
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
              builder: (context, constraints) => _settingPageContent(
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

  Widget _settingPageContent(final BuildContext context, final Size size) {
    return Container();
  }
}

import 'package:flutter/cupertino.dart';

class SettingPage extends StatefulWidget {
  static const String id = 'setting_page';
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: '取消',
        middle: const Text('設定'),
        trailing: GestureDetector(
          onTap: () async {
            // finish configuration
            Navigator.pop(context);
          },
          child: const Text(
            '完成',
            style: TextStyle(color: CupertinoColors.systemBlue),
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
    );
  }

  Widget _settingPageContent(final BuildContext context, final Size size) {
    return Container();
  }
}

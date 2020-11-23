import 'package:flutter/cupertino.dart';
import 'package:settings_ui/settings_ui.dart';

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
              Navigator.pop(context, '已保存');
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
              builder: (context, constraints) => settingPageContent(
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

  Widget settingPageContent(final BuildContext context, final Size size) {
    return Container(
      child: SettingsList(
        sections: [
          SettingsSection(
            title: '主題',
            titleTextStyle: TextStyle(color: CupertinoDynamicColor.resolve(CupertinoColors.systemBackground, context)),
            tiles: [
              /*SettingsTile.switchTile(
                title: '深色主題',
                leading: Icon(
                  CupertinoIcons.photo,
                  semanticLabel: setting.themeLabel,
                  color:
                      CupertinoDynamicColor.resolve(setting.iconColor, context),
                ),
                onToggle: (value) {},
                switchValue: false,
              ),*/
            ],
          ),
        ],
      ),
    );
  }
}

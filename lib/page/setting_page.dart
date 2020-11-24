import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerpass/setting/setting.dart' as setting;
import 'package:pokerpass/setting/user.dart';
import 'package:pokerpass/utility/widget/cupertino_swith_list_tile.dart';

class SettingPage extends StatefulWidget {
  static const id = 'setting_page';
  SettingPage({final Key key}) : super(key: key);
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var isDarkThemeModeTemp = UserData.snapshot.data == Brightness.dark;
  var isSystemThemeModeTemp = UserData.isSystemThemeMode;

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
              UserData.isSystemThemeMode = isSystemThemeModeTemp;
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
        UserData.brightness.add(UserData.isSystemThemeMode
            ? setting.platformBrightness
            : isDarkThemeModeTemp
                ? Brightness.dark
                : Brightness.light);
        return true;
      },
    );
  }

  Widget settingPageContent(final BuildContext context, final Size size) {
    return Scaffold(
      backgroundColor: CupertinoDynamicColor.resolve(setting.bgColor, context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.photo,
                  semanticLabel: setting.themeLabel,
                  color:
                      CupertinoDynamicColor.resolve(setting.iconColor, context),
                ),
                Text(
                  '主題',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    color: CupertinoDynamicColor.resolve(
                        setting.promptTextColor, context),
                  ),
                ),
              ],
            ),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black26))),
          ),
          CupertinoSwitchListTile(
            title: Text('根據系統主題',
                style: TextStyle(
                  color: CupertinoDynamicColor.resolve(
                      setting.promptTextColor, context),
                )),
            onChanged: (value) {
              if (value) UserData.brightness.add(setting.platformBrightness);
              setState(() => isSystemThemeModeTemp = value);
            },
            value: isSystemThemeModeTemp,
          ),
          CupertinoSwitchListTile(
            title: Text(
              '深色主題',
              style: TextStyle(
                color: CupertinoDynamicColor.resolve(
                    setting.promptTextColor, context),
              ),
            ),
            onChanged: !isSystemThemeModeTemp
                ? (value) => UserData.brightness
                    .add(value ? Brightness.dark : Brightness.light)
                : null,
            value: UserData.snapshot.data == Brightness.dark,
          ),
        ],
      ),
    );
  }
}

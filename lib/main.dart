import 'dart:io';
import 'dart:ui';
import 'package:window_size/window_size.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
          center: screen.frame.center,
          width: MyApp.WIDTH,
          height: MyApp.HEIGHT));
    });
    setWindowTitle('PokerPass');
    setWindowMinSize(Size(MyApp.WIDTH, MyApp.HEIGHT));
    setWindowMaxSize(Size(MyApp.WIDTH, MyApp.HEIGHT));
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const WIDTH = 800.0;
  static const HEIGHT = 600.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokerPass System',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'PokerPass'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              onPressed: () {},
              child: Text(
                '登入',
                style: TextStyle(fontSize: 36),
              ),
              color: Colors.blue,
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 20,
              ),
            ),
            const SizedBox(
              height: 75,
            ),
            FlatButton(
              onPressed: () {},
              child: Text(
                '註冊',
                style: TextStyle(fontSize: 36),
              ),
              color: Colors.yellow,
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

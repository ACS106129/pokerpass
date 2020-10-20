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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
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

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerpass/setting/setting.dart' as setting;
import 'package:pokerpass/utility/area.dart';
import 'package:pokerpass/utility/argument/qr_argument.dart';
import 'package:pokerpass/utility/transmission.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodePage extends StatefulWidget {
  static const id = 'qrcode_page';
  QRCodePage({final Key key}) : super(key: key);
  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  QRArgument qrArgument;

  @override
  Widget build(final BuildContext context) {
    qrArgument = ModalRoute.of(context).settings.arguments;
    return WillPopScope(
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          previousPageTitle: '返回',
          middle: const Text('掃描QRCode'),
        ),
        child: SafeArea(
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) => _qrcodePageContent(
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

  Widget _qrcodePageContent(
      final BuildContext context, final Size contentSize) {
    return Container(
      width: getSafeArea(context).width * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          setting.isDesktop
              ? QrImage(
                  data:
                      'https://www.test.com/?session=JIFnifaoifjI&random_server=1234567890&random_client=',
                  version: QrVersions.auto,
                  size: 200.0,
                )
              : Text(getHmacValue(
                  Random().nextInt(1 << 32).toString(), 'asshole')),
        ],
      ),
    );
  }
}

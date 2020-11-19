import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerpass/utility/area.dart';
import 'package:pokerpass/utility/transmission.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:pokerpass/setting/Setting.dart' as setting;

class QRCodePage extends StatefulWidget {
  static const String id = 'qrcode_page';
  final String qrString;
  QRCodePage({this.qrString = ''});
  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: '返回',
        middle: const Text('掃描QRCode'),
      ),
      child: SafeArea(
        child: Center(
          child: _qrcodePageContent(context),
        ),
      ),
    );
  }

  Widget _qrcodePageContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: getSafeArea(context).width * 0.8,
          child: Column(
            children: [
              setting.isDesktop
                  ? QrImage(
                      data:
                          'https://www..com/?session=JIFnifaoifjI&random_server=1234567890&random_client=',
                      version: QrVersions.auto,
                      size: 200.0,
                    )
                  : Text(getHmacValue(
                      Random().nextInt(1 << 32).toString(), 'asshole')),
            ],
          ),
        ),
      ],
    );
  }
}

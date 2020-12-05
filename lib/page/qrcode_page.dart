import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerpass/setting/setting.dart';
import 'package:pokerpass/utility/area.dart';
import 'package:pokerpass/utility/argument/qr_argument.dart';
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
    final args = ModalRoute.of(context).settings.arguments;
    qrArgument = args is QRArgument ? args : QRArgument.fromString(args);
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
          Setting.isDesktop
              ? QrImage(
                  data: qrArgument.toString(),
                  version: QrVersions.auto,
                  size: 200.0,
                )
              : Text('Type: ${qrArgument.type}\n' +
                  'Device Key: ${qrArgument.deviceKey}\n' +
                  'Session ID: ${qrArgument.sessionId}\n'
                      'URL: ${qrArgument.url}\n' +
                  'User: ${qrArgument.user}\n' +
                  'Password: ${qrArgument.password}\n' +
                  'Client Random: ${qrArgument.clientRandom}\n' +
                  'Server Random: ${qrArgument.serverRandom}'),
        ],
      ),
    );
  }
}

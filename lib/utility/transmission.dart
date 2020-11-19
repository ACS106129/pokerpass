import 'dart:convert';
//import 'dart:html';

import 'package:crypto/crypto.dart';

String getHmacValue(final String serverRandom, final String deviceKey) {
  final byteKey = utf8.encode(deviceKey);
  final hmac256 = new Hmac(sha256, byteKey);
  return '${hmac256.convert(utf8.encode(serverRandom))}';
}

// Get server's session id and random number
List<String> getServerData(final String url) {
  return [];
}

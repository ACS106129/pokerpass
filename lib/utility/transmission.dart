import 'dart:convert';

import 'package:crypto/crypto.dart';

class RegisterResponse {
  static const Deny = 'deny';
  static const AccountExist = 'account exist';
  static const Accept = 'accept';
}

String getHmacValue(final String serverRandom, final String deviceKey) {
  final byteKey = utf8.encode(deviceKey);
  final hmac256 = Hmac(sha256, byteKey);
  return '${hmac256.convert(utf8.encode(serverRandom))}';
}

// Get server's session id and random number
List<String> getServerData(final String url) {
  return [];
}

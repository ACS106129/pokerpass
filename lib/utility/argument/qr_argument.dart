class ProcessType {
  static const Register = 'register';
  static const TwoFA = 'twoFA';
}

class QRArgument {
  // argument used process
  final String type;

  /// mobile store device key
  final String deviceKey;

  /// communication session id
  final String sessionId;

  /// random value challenge from server
  final String serverRandom;

  /// random value challenge from client
  final String clientRandom;

  /// server url
  final String url;

  /// user id
  final String user;

  /// user password
  final String password;

  QRArgument(final this.type,
      {final this.deviceKey,
      final this.sessionId,
      final this.serverRandom,
      final this.clientRandom,
      final this.url,
      final this.user,
      final this.password});

  @override
  String toString() {
    return '$type|$deviceKey|$sessionId|$serverRandom|$clientRandom|$url|$user|$password';
  }

  static QRArgument fromString(String str) {
    final args = str.split('|');
    return QRArgument(args[0],
        deviceKey: args[1],
        sessionId: args[2],
        serverRandom: args[3],
        clientRandom: args[4],
        url: args[5],
        user: args[6],
        password: args[7]);
  }
}

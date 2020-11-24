class QRArgument {
  // argument used process
  final ProcessType type;

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
}

enum ProcessType { Register, TwoFA }

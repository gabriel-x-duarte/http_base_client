import 'dart:io' show Socket;

abstract final class InternetConnectionChecker {
  const InternetConnectionChecker();

  static Future<bool> get check async => await _checkInternetConnection();

  static Future<bool> _checkInternetConnection() async {
    try {
      const int port = 53;

      // Tries to connect to Google DNS (8.8.8.8) or Cloudflare DNS (1.1.1.1)
      return await _trySocketConnection(
            '8.8.8.8',
            port,
          ) ||
          await _trySocketConnection(
            '1.1.1.1',
            port,
          );
    } catch (_) {
      return false;
    }
  }

  static Future<bool> _trySocketConnection(String host, int port) async {
    try {
      final socket = await Socket.connect(
        host,
        port,
        timeout: const Duration(milliseconds: 2000),
      );

      socket.destroy();

      return true;
    } catch (_) {
      return false;
    }
  }
}

/// A minimalistic http client.

library;

import 'dart:convert' as converter;
import 'dart:io' show Socket;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Defines a minimalistic HTTP client contract.
abstract interface class HttpBaseClient {
  const factory HttpBaseClient() = _HttpBaseClient;

  /// Checks whether the device has internet connectivity.
  Future<bool> get checkInternetConnection;

  /// Makes a GET request.
  Future<HttpBaseClientResponse> get(
    Uri uri, {
    Map<String, String>? headers = const {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
    },
  });

  /// Makes a POST request.
  Future<HttpBaseClientResponse> post(
    Uri uri, {
    Map<String, String>? headers = const {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
    },
    Object? requestBody,
  });

  /// Makes a PUT request.
  Future<HttpBaseClientResponse> put(
    Uri uri, {
    Map<String, String>? headers = const {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
    },
    Object? requestBody,
  });

  /// Makes a PATCH request.
  Future<HttpBaseClientResponse> patch(
    Uri uri, {
    Map<String, String>? headers = const {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
    },
    Object? requestBody,
  });

  /// Makes a DELETE request.
  Future<HttpBaseClientResponse> delete(
    Uri uri, {
    Map<String, String>? headers = const {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
    },
    Object? requestBody,
  });
}

final class _HttpBaseClient implements HttpBaseClient {
  const _HttpBaseClient();

  /// Checks whether the device has internet connectivity.
  @override
  Future<bool> get checkInternetConnection async => await _checkInternetConnection();

  Future<bool> _checkInternetConnection() async {
    try {
      const int port = 53;

      // Returns true on Web because dart:io socket checks are not supported.
      if (kIsWeb) {
        return true;
      }

      // Trying to connect with Google ip (8.8.8.8) or Cloudflare (1.1.1.1)
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

  Future<bool> _trySocketConnection(String host, int port) async {
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

  /// Generic method to process all requests
  Future<HttpBaseClientResponse> _processRequest(
    Future<http.Response> Function(http.Client client) requestCall,
  ) async {
    // Verify if internet connection is working
    if (!await _checkInternetConnection()) {
      return HttpBaseClientResponse._fromException(
        "No internet connection",
      );
    }

    final client = http.Client();

    HttpBaseClientResponse res;

    try {
      final response = await requestCall(client);

      res = HttpBaseClientResponse._fromHttpResponse(response);
    } catch (err) {
      res = HttpBaseClientResponse._fromException(err.toString());
    } finally {
      client.close();
    }

    return res;
  }

  /// Makes a GET request.
  @override
  Future<HttpBaseClientResponse> get(
    Uri uri, {
    Map<String, String>? headers = const {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
    },
  }) async {
    return _processRequest(
      (client) => client.get(
        uri,
        headers: headers,
      ),
    );
  }

  /// Makes a POST request.
  @override
  Future<HttpBaseClientResponse> post(
    Uri uri, {
    Map<String, String>? headers = const {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
    },
    Object? requestBody,
  }) async {
    return _processRequest(
      (client) => client.post(
        uri,
        headers: headers,
        body: requestBody,
      ),
    );
  }

  /// Makes a PUT request.
  @override
  Future<HttpBaseClientResponse> put(
    Uri uri, {
    Map<String, String>? headers = const {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
    },
    Object? requestBody,
  }) async {
    return _processRequest(
      (client) => client.put(
        uri,
        headers: headers,
        body: requestBody,
      ),
    );
  }

  /// Makes a PATCH request.
  @override
  Future<HttpBaseClientResponse> patch(
    Uri uri, {
    Map<String, String>? headers = const {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
    },
    Object? requestBody,
  }) async {
    return _processRequest(
      (client) => client.patch(
        uri,
        headers: headers,
        body: requestBody,
      ),
    );
  }

  /// Makes a DELETE request.
  @override
  Future<HttpBaseClientResponse> delete(
    Uri uri, {
    Map<String, String>? headers = const {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
    },
    Object? requestBody,
  }) async {
    return _processRequest(
      (client) => client.delete(
        uri,
        headers: headers,
        body: requestBody,
      ),
    );
  }
}

/// A wrapper around the http.Response class.
///
/// Returns status code -1 when a client-side error occurs,
/// such as no internet connection or a socket exception.
class HttpBaseClientResponse {
  /// The HTTP status code for this response.
  final int statusCode;

  /// The reason phrase associated with the status code.
  final String reasonPhrase;

  /// The body of the response as a string.
  ///
  /// This is converted from [bodyBytes] using the charset parameter of the Content-Type header field, if available. If it's unavailable or if the encoding name is unknown, [latin1] is used by default, as per RFC 2616.
  final String body;

  /// The HTTP headers returned by the server.
  ///
  /// The header names are converted to lowercase and stored with their associated header values.
  final Map<String, String> headers;

  const HttpBaseClientResponse(
    this.statusCode,
    this.reasonPhrase,
    this.body,
    this.headers,
  );

  factory HttpBaseClientResponse._fromHttpResponse(
    http.Response response,
  ) {
    return HttpBaseClientResponse(
      response.statusCode,
      response.reasonPhrase ?? "",
      response.body,
      response.headers,
    );
  }

  factory HttpBaseClientResponse._fromException(
    String? message,
  ) {
    return HttpBaseClientResponse(
      -1,
      message ?? "",
      "",
      {},
    );
  }

  /// Returns the parsed JSON or null
  dynamic get data => _parseResponseBody();

  /// Returns the parsed JSON asynchronously or null
  Future<dynamic> get dataAsFuture async {
    return await Future<dynamic>.value(_parseResponseBody());
  }

  dynamic _parseResponseBody() {
    if (body.isEmpty) {
      return null;
    }

    try {
      return converter.json.decode(body);
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> _toMap() {
    return {
      "statusCode": statusCode,
      "reasonPhrase": reasonPhrase,
      "body": body,
      "headers": headers,
    };
  }

  Map<String, dynamic> toMap() => _toMap();

  String toJson() {
    return converter.jsonEncode(_toMap());
  }

  @override
  String toString() {
    return toJson();
  }
}

abstract class ObjectConverter {
  static String jsonEncode(Object object) {
    final string = converter.json.encode(object);

    return string;
  }

  static dynamic jsonDecode(String source) {
    final json = converter.json.decode(source);

    return json;
  }

  static Uint8List utf8Encode(String source) {
    final chars = converter.utf8.encode(source);

    return chars;
  }

  static String utf8Decode(List<int> source) {
    final string = converter.utf8.decode(source);

    return string;
  }

  static String base64Encode(List<int> source) {
    final string = converter.base64.encode(source);

    return string;
  }

  static Uint8List base64Decode(String source) {
    final chars = converter.base64.decode(source);

    return chars;
  }

  static String base64UrlEncode(List<int> source) {
    final string = converter.base64Url.encode(source);

    return string;
  }

  static Uint8List base64UrlDecode(String source) {
    final chars = converter.base64Url.decode(source);

    return chars;
  }
}

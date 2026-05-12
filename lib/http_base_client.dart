/// A minimalistic HTTP client.

library;

import 'dart:convert' as converter;
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'src/internet_connection_checker.dart';

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
  Future<bool> get checkInternetConnection async => await InternetConnectionChecker.check;

  /// Processes all HTTP requests through a shared flow.
  Future<HttpBaseClientResponse> _processRequest(
    Future<http.Response> Function(http.Client client) requestCall,
  ) async {
    // Verifies internet connectivity.
    if (!await InternetConnectionChecker.check) {
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

/// A wrapper around the `http.Response` class.
///
/// Returns status code `-1` when a client-side error occurs,
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

  /// Returns the parsed JSON or null.
  dynamic get data => _parseResponseBody();

  /// Returns the parsed JSON asynchronously or null.
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
    return <String, dynamic>{
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

/// Utility class for common data encoding and decoding operations.
///
/// Provides helpers for:
/// - JSON encoding and decoding
/// - UTF-8 encoding and decoding
/// - Base64 encoding and decoding
/// - Base64URL encoding and decoding
abstract final class DataCodec {
  /// Encodes an object into a JSON string.
  static String jsonEncode(Object data) {
    final string = converter.json.encode(data);

    return string;
  }

  /// Decodes a JSON string into a Dart object.
  static dynamic jsonDecode(String data) {
    final json = converter.json.decode(data);

    return json;
  }

  /// Encodes a string into UTF-8 bytes.
  static Uint8List utf8Encode(String data) {
    final chars = converter.utf8.encode(data);

    return chars;
  }

  /// Decodes UTF-8 bytes into a string.
  static String utf8Decode(List<int> data) {
    final string = converter.utf8.decode(data);

    return string;
  }

  /// Encodes bytes into a Base64 string.
  static String base64Encode(List<int> data) {
    final string = converter.base64.encode(data);

    return string;
  }

  /// Decodes a Base64 string into bytes.
  static Uint8List base64Decode(String data) {
    final chars = converter.base64.decode(data);

    return chars;
  }

  /// Encodes bytes into a Base64URL string.
  static String base64UrlEncode(List<int> data) {
    final string = converter.base64Url.encode(data);

    return string;
  }

  /// Decodes a Base64URL string into bytes.
  static Uint8List base64UrlDecode(String data) {
    final chars = converter.base64Url.decode(data);

    return chars;
  }
}

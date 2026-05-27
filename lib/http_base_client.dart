/// A minimalistic HTTP client.

library;

import 'dart:convert' as converter;
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'src/internet_connection_checker.dart';

/// Defines a minimalistic HTTP client contract.
abstract interface class HttpBaseClient {
  /// Creates an HTTP client instance that creates and closes
  /// a new underlying client for each request.
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

/// Defines an HTTP client contract that reuses the same underlying client
/// across multiple requests.
abstract interface class PersistentHttpBaseClient implements HttpBaseClient {
  /// Creates an HTTP client instance that persists across multiple requests.
  factory PersistentHttpBaseClient() = _PersistentHttpBaseClient;

  /// Whether this HTTP client has already been closed.
  bool get isClosed;

  /// Closes the underlying persistent HTTP client.
  void close();
}

/// Provides shared HTTP request behavior for all internal client implementations.
abstract base class _HttpRequestProcessor implements HttpBaseClient {
  const _HttpRequestProcessor();

  static const String _noInternetConnectionMessage = "No internet connection";

  static const Map<String, String> _defaultHeaders = {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded",
  };

  @override
  Future<bool> get checkInternetConnection async => await InternetConnectionChecker.check;

  /// Processes all HTTP requests through a shared flow.
  Future<HttpBaseClientResponse> _processRequest(
    Future<http.Response> Function(http.Client client) requestCall,
  );

  /// Converts an `http.Response` into a `HttpBaseClientResponse`.
  HttpBaseClientResponse _processResponse(
    http.Response response,
  ) {
    return HttpBaseClientResponse._fromHttpResponse(
      response,
    );
  }

  /// Converts a request failure or internal error into a `HttpBaseClientResponse`.
  HttpBaseClientResponse _processException(
    Object error,
  ) {
    return HttpBaseClientResponse._fromException(
      error.toString(),
    );
  }

  /// Creates a response for no internet connection scenarios.
  HttpBaseClientResponse _processNoInternetConnection() {
    return HttpBaseClientResponse._fromException(
      _noInternetConnectionMessage,
    );
  }

  @override
  Future<HttpBaseClientResponse> get(
    Uri uri, {
    Map<String, String>? headers = _defaultHeaders,
  }) async {
    return _processRequest(
      (client) => client.get(
        uri,
        headers: headers,
      ),
    );
  }

  @override
  Future<HttpBaseClientResponse> post(
    Uri uri, {
    Map<String, String>? headers = _defaultHeaders,
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

  @override
  Future<HttpBaseClientResponse> put(
    Uri uri, {
    Map<String, String>? headers = _defaultHeaders,
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

  @override
  Future<HttpBaseClientResponse> patch(
    Uri uri, {
    Map<String, String>? headers = _defaultHeaders,
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

  @override
  Future<HttpBaseClientResponse> delete(
    Uri uri, {
    Map<String, String>? headers = _defaultHeaders,
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

/// Internal HTTP client implementation that creates and disposes
/// an `http.Client` for each request.
final class _HttpBaseClient extends _HttpRequestProcessor {
  const _HttpBaseClient();

  @override
  Future<HttpBaseClientResponse> _processRequest(
    Future<http.Response> Function(http.Client client) requestCall,
  ) async {
    // Verifies internet connectivity.
    if (!await checkInternetConnection) {
      return _processNoInternetConnection();
    }

    final client = http.Client();

    HttpBaseClientResponse res;

    try {
      final response = await requestCall(client);

      res = _processResponse(response);
    } catch (err) {
      res = _processException(err);
    } finally {
      client.close();
    }

    return res;
  }
}

/// Internal persistent HTTP client implementation that reuses
/// the same `http.Client` across multiple requests.
final class _PersistentHttpBaseClient extends _HttpRequestProcessor
    implements PersistentHttpBaseClient {
  static const String _closedClientMessage = "HTTP client is closed";

  final http.Client _client;

  bool _isClosed = false;

  _PersistentHttpBaseClient() : _client = http.Client();

  @override
  bool get isClosed => _isClosed;

  @override
  Future<HttpBaseClientResponse> _processRequest(
    Future<http.Response> Function(http.Client client) requestCall,
  ) async {
    if (_isClosed) {
      return _processException(
        _closedClientMessage,
      );
    }

    if (!await checkInternetConnection) {
      return _processNoInternetConnection();
    }

    try {
      final response = await requestCall(_client);

      return _processResponse(response);
    } catch (err) {
      return _processException(err);
    }
  }

  @override
  void close() {
    if (_isClosed) {
      return;
    }

    _client.close();
    _isClosed = true;
  }
}

/// A wrapper around the `http.Response` class.
///
/// Returns status code `-1` when a client-side error occurs,
/// such as no internet connection or a socket exception.
class HttpBaseClientResponse {
  /// The status code used when a request fails before receiving
  /// a valid HTTP response, such as no internet connection or a socket exception.
  static const int clientSideErrorStatusCode = -1;

  /// The HTTP status code for this response.
  final int statusCode;

  /// The reason phrase associated with the status code.
  final String reasonPhrase;

  /// The body of the response as a string.
  ///
  /// This is converted from [bodyBytes] using the charset parameter of the Content-Type header field, if available. If it's unavailable or if the encoding name is unknown, [latin1] is used by default, as per RFC 2616.
  final String body;

  /// The bytes comprising the body of this response.
  final Uint8List bodyBytes;

  /// The HTTP headers returned by the server.
  ///
  /// The header names are converted to lowercase and stored with their associated header values.
  final Map<String, String> headers;

  /// Creates an HTTP response instance.
  const HttpBaseClientResponse({
    required this.statusCode,
    required this.reasonPhrase,
    required this.body,
    required this.bodyBytes,
    required this.headers,
  });

  factory HttpBaseClientResponse._fromHttpResponse(
    http.Response response,
  ) {
    return HttpBaseClientResponse(
      statusCode: response.statusCode,
      reasonPhrase: response.reasonPhrase ?? "",
      body: response.body,
      bodyBytes: response.bodyBytes,
      headers: response.headers,
    );
  }

  factory HttpBaseClientResponse._fromException(
    String? message,
  ) {
    return HttpBaseClientResponse(
      statusCode: clientSideErrorStatusCode,
      reasonPhrase: message ?? "",
      body: "",
      bodyBytes: Uint8List(0),
      headers: <String, String>{},
    );
  }

  /// Whether this response represents a successful HTTP status code
  /// in the 200-299 range.
  bool get isSuccessStatusCode => statusCode >= 200 && statusCode < 300;

  /// Whether this response represents a failure before receiving
  /// a valid HTTP response, such as no internet connection or a socket exception.
  bool get isClientSideError => statusCode == clientSideErrorStatusCode;

  /// Returns the parsed JSON or null.
  dynamic get data => _parseResponseBody();

  /// Returns the parsed JSON asynchronously or null.
  Future<dynamic> get dataAsFuture async {
    return _parseResponseBody();
  }

  dynamic _parseResponseBody() {
    if (body.isEmpty) {
      return null;
    }

    try {
      return DataCodec.jsonDecode(body);
    } catch (e) {
      return null;
    }
  }

  /// `bodyBytes` is intentionally omitted to avoid
  /// large binary payload serialization.
  Map<String, dynamic> _toMap() {
    return <String, dynamic>{
      "statusCode": statusCode,
      "reasonPhrase": reasonPhrase,
      "body": body,
      "headers": headers,
    };
  }

  /// A `Map<String, dynamic>` representation of this object.
  Map<String, dynamic> toMap() => _toMap();

  /// A JSON string representation of this object.
  String toJson() {
    return DataCodec.jsonEncode(_toMap());
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

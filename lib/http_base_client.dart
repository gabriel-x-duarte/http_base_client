/// A minimalistic http client.

library http_base_client;

import 'dart:convert' as converter;
import 'dart:io';

import 'package:http/http.dart' as http;

/// A abstract class to handle http requests
abstract class HttpBaseClient {
  /// To check internet connection
  static Future<bool> get checkInternetConnection async =>
      await _checkInternetConnection();

  static Future<bool> _checkInternetConnection() async {
    try {
      final response = await InternetAddress.lookup("dart.dev");

      if (response.isNotEmpty && response[0].rawAddress.isNotEmpty) {
        return true;
      }

      return false;
    } catch (_) {
      return false;
    }
  }

  /// To make a get request
  static Future<HttpBaseClientResponse> get(
    Uri uri, {
    Map<String, String>? headers = const {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    },
  }) async {
    var client = http.Client();

    HttpBaseClientResponse res;

    try {
      var response = await client.get(
        uri,
        headers: headers,
      );

      res = HttpBaseClientResponse._fromHttpResponse(response);
    } catch (err) {
      res = HttpBaseClientResponse._fromException(err.toString());
    } finally {
      client.close();
    }

    return res;
  }

  /// To make a post request
  static Future<HttpBaseClientResponse> post(
    Uri uri, {
    Map<String, String>? headers = const {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    },
    Object? requestBody,
  }) async {
    var client = http.Client();

    HttpBaseClientResponse res;

    try {
      var response = await client.post(
        uri,
        headers: headers,
        body: requestBody,
      );

      res = HttpBaseClientResponse._fromHttpResponse(response);
    } catch (err) {
      res = HttpBaseClientResponse._fromException(err.toString());
    } finally {
      client.close();
    }

    return res;
  }

  /// To make a put request
  static Future<HttpBaseClientResponse> put(
    Uri uri, {
    Map<String, String>? headers = const {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    },
    Object? requestBody,
  }) async {
    var client = http.Client();

    HttpBaseClientResponse res;

    try {
      var response = await client.put(
        uri,
        headers: headers,
        body: requestBody,
      );

      res = HttpBaseClientResponse._fromHttpResponse(response);
    } catch (err) {
      res = HttpBaseClientResponse._fromException(err.toString());
    } finally {
      client.close();
    }

    return res;
  }

  /// To make a patch request
  static Future<HttpBaseClientResponse> patch(
    Uri uri, {
    Map<String, String>? headers = const {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    },
    Object? requestBody,
  }) async {
    var client = http.Client();

    HttpBaseClientResponse res;

    try {
      var response = await client.patch(
        uri,
        headers: headers,
        body: requestBody,
      );

      res = HttpBaseClientResponse._fromHttpResponse(response);
    } catch (err) {
      res = HttpBaseClientResponse._fromException(err.toString());
    } finally {
      client.close();
    }

    return res;
  }

  /// To make a delete request
  static Future<HttpBaseClientResponse> delete(
    Uri uri, {
    Map<String, String>? headers = const {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    },
    Object? requestBody,
  }) async {
    var client = http.Client();

    HttpBaseClientResponse res;

    try {
      var response = await client.delete(
        uri,
        headers: headers,
        body: requestBody,
      );

      res = HttpBaseClientResponse._fromHttpResponse(response);
    } catch (err) {
      res = HttpBaseClientResponse._fromException(err.toString());
    } finally {
      client.close();
    }

    return res;
  }
}

/// A Wrapper around the http.Response class.
/// Will return status -1 if any client side error occurs,
/// such as NO Internet connection or Socket Exceptions
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
  dynamic get data => _parsePayload();

  /// Returns asynchronously the parsed JSON or null
  Future<dynamic> get dataAsFuture async => await _parsePayloadAsync();

  dynamic _parsePayload() {
    if (body.isEmpty) {
      return null;
    }

    try {
      return converter.json.decode(body);
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> _parsePayloadAsync() async {
    return _parsePayload();
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

  static List<int> utf8Encode(String source) {
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

  static List<int> base64Decode(String source) {
    final chars = converter.base64.decode(source);

    return chars;
  }

  static String base64UrlEncode(List<int> source) {
    final string = converter.base64Url.encode(source);

    return string;
  }

  static List<int> base64UrlDecode(String source) {
    final chars = converter.base64Url.decode(source);

    return chars;
  }
}

/// A minimalistic http client.

library http_base_client;

import 'package:universal_io/io.dart';

import 'dart:convert' as converter;
//import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

/// A abstract class to handle http requests
abstract class HttpBaseClient {
  /// To check internet connection
  static Future<bool> get checkInternetConnection async =>
      await _checkInternetConnection();

  static Future<bool> _checkInternetConnection() async {
    /// The package Universal IO now return the information properly
    //if (kIsWeb) {
    //  return true;
    //}

    try {
      final response = await InternetAddress.lookup("dart.dev");

      if (response.isNotEmpty) {
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
      res = HttpBaseClientResponse._fromError(err.toString());
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
      res = HttpBaseClientResponse._fromError(err.toString());
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
      res = HttpBaseClientResponse._fromError(err.toString());
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
      res = HttpBaseClientResponse._fromError(err.toString());
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
      res = HttpBaseClientResponse._fromError(err.toString());
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
  final int status;
  final String message;
  final String payload;
  final Map<String, String> headers;

  const HttpBaseClientResponse(
    this.status,
    this.message,
    this.payload,
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

  factory HttpBaseClientResponse._fromError(
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
  Future<Object?> get data => _parsePayload();

  Future<Object?> _parsePayload() async {
    if (payload.isEmpty) {
      return null;
    }

    try {
      return converter.json.decode(payload);
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> _toMap() {
    return {
      "status": status,
      "message": message,
      "payload": payload,
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

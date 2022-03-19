/// A minimalistic http client.

library http_base_client;

import 'package:universal_io/io.dart';

import 'dart:convert' as converter;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

abstract class HttpBaseClient {
  /// To check internet connection
  static Future<bool> get checkInternetConnection async =>
      await _checkInternetConnection();

  static Future<bool> _checkInternetConnection() async {
    if (kIsWeb) {
      return true;
    }

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

    HttpBaseClientResponse _res;

    try {
      var response = await client.get(
        uri,
        headers: headers,
      );

      _res = HttpBaseClientResponse._fromHttpBaseClientResponse(response);
    } catch (err) {
      _res = HttpBaseClientResponse._fromError(err.toString());
    } finally {
      client.close();
    }

    return _res;
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

    HttpBaseClientResponse _res;

    try {
      var response = await client.post(
        uri,
        headers: headers,
        body: requestBody,
      );

      _res = HttpBaseClientResponse._fromHttpBaseClientResponse(response);
    } catch (err) {
      _res = HttpBaseClientResponse._fromError(err.toString());
    } finally {
      client.close();
    }

    return _res;
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

    HttpBaseClientResponse _res;

    try {
      var response = await client.put(
        uri,
        headers: headers,
        body: requestBody,
      );

      _res = HttpBaseClientResponse._fromHttpBaseClientResponse(response);
    } catch (err) {
      _res = HttpBaseClientResponse._fromError(err.toString());
    } finally {
      client.close();
    }

    return _res;
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

    HttpBaseClientResponse _res;

    try {
      var response = await client.patch(
        uri,
        headers: headers,
        body: requestBody,
      );

      _res = HttpBaseClientResponse._fromHttpBaseClientResponse(response);
    } catch (err) {
      _res = HttpBaseClientResponse._fromError(err.toString());
    } finally {
      client.close();
    }

    return _res;
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

    HttpBaseClientResponse _res;

    try {
      var response = await client.delete(
        uri,
        headers: headers,
        body: requestBody,
      );

      _res = HttpBaseClientResponse._fromHttpBaseClientResponse(response);
    } catch (err) {
      _res = HttpBaseClientResponse._fromError(err.toString());
    } finally {
      client.close();
    }

    return _res;
  }
}

class HttpBaseClientResponse {
  final int _status;
  final String _message;
  final String _payload;
  final Map<String, String> _headers;

  const HttpBaseClientResponse._(
    this._status,
    this._message,
    this._payload,
    this._headers,
  );

  factory HttpBaseClientResponse._fromHttpBaseClientResponse(
      http.Response _response) {
    return HttpBaseClientResponse._(
      _response.statusCode,
      _response.reasonPhrase ?? "",
      _response.body,
      _response.headers,
    );
  }

  factory HttpBaseClientResponse._fromError(String? message) {
    return HttpBaseClientResponse._(
      400,
      message ?? "",
      "",
      {},
    );
  }

  int get status => _status;
  String get message => _message;
  String get payload => _payload;
  Map<String, String> get headers => _headers;

  Map<String, dynamic> _toMap() {
    return {
      "status": _status,
      "message": _message,
      "payload": _payload,
      "headers": _headers,
    };
  }

  Map<String, dynamic> get toMap => _toMap();

  @override
  String toString() {
    return converter.jsonEncode(_toMap());
  }
}

abstract class ObjectConverter {
  static String jsonEncode(Object object) {
    final _string = converter.json.encode(object);

    return _string;
  }

  static dynamic jsonDecode(String source) {
    final _json = converter.json.decode(source);

    return _json;
  }

  static List<int> utf8Encode(String source) {
    final _chars = converter.utf8.encode(source);

    return _chars;
  }

  static String utf8Decode(List<int> source) {
    final _string = converter.utf8.decode(source);

    return _string;
  }

  static String base64Encode(List<int> source) {
    final _string = converter.base64.encode(source);

    return _string;
  }

  static List<int> base64Decode(String source) {
    final _chars = converter.base64.decode(source);

    return _chars;
  }

  static String base64UrlEncode(List<int> source) {
    final _string = converter.base64Url.encode(source);

    return _string;
  }

  static List<int> base64UrlDecode(String source) {
    final _chars = converter.base64Url.decode(source);

    return _chars;
  }
}

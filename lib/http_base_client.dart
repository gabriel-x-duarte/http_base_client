library http_base_client;

/// A minimalistic http client.
import 'dart:convert';

import 'package:universal_io/io.dart';
import 'package:http/http.dart' as http;

abstract class HttpBaseClient {
  /// TO CHECK INTERNET CONNECTION
  static Future<bool> get checkInternetConnection async =>
      await _checkInternetConnection();

  static Future<bool> _checkInternetConnection() async {
    try {
      final response = await InternetAddress.lookup("dart.dev");

      if (response.isNotEmpty) {
        return true;
      }

      return false;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// TO MAKE A GET REQUEST
  static Future<HttpBaseClientResponse> get(
    Uri uri, [
    Map<String, String>? headers = const {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    },
  ]) async {
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

  /// TO MAKE A POST REQUEST
  static Future<HttpBaseClientResponse> post(
    Uri uri, [
    Map<String, String>? headers = const {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    },
    Object? requestBody,
  ]) async {
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

  /// TO MAKE A PUT REQUEST
  static Future<HttpBaseClientResponse> put(
    Uri uri, [
    Map<String, String>? headers = const {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    },
    Object? requestBody,
  ]) async {
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

  /// TO MAKE A PATCH REQUEST
  static Future<HttpBaseClientResponse> patch(
    Uri uri, [
    Map<String, String>? headers = const {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    },
    Object? requestBody,
  ]) async {
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

  /// TO MAKE A DELETE REQUEST
  static Future<HttpBaseClientResponse> delete(
    Uri uri, [
    Map<String, String>? headers = const {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    },
    Object? requestBody,
  ]) async {
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
    return jsonEncode(_toMap());
  }
}

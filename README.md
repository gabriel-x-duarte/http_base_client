<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

A minimalistic and lightweight HTTP client for Dart and Flutter.
## Features

- Simple and easy-to-use HTTP request API.
- Supports GET, POST, PUT, PATCH, and DELETE requests.
- Built-in internet connectivity checker.
- Synchronous and asynchronous JSON parsing helpers.
- Lightweight and minimal architecture.
- Easy to mock and test.
- Compatible with Mobile, Desktop, and Web platforms.

> **Note**
>
> Web browsers do not support direct `dart:io` socket connections.
>
> Because of this limitation, `checkInternetConnection` always returns `true` on Web platforms.
>
> For all other platforms (Mobile and Desktop), the socket-based connection check remains fully functional.

## Usage

```dart
import 'dart:developer';

import 'package:http_base_client/http_base_client.dart';

Future<void> main() async {
  const httpClient = HttpBaseClient();

  // CHECK INTERNET CONNECTIVITY
  final hasConnection = await httpClient.checkInternetConnection;

  if (!hasConnection) {
    log('No internet connection.');

    return;
  }

  // MAKING A GET REQUEST
  final usersResponse = await httpClient.get(
    Uri.parse(
      'https://jsonplaceholder.typicode.com/users',
    ),
  );

  log('GET STATUS CODE: ${usersResponse.statusCode}');

  if (usersResponse.body.isNotEmpty) {
    log('GET RESPONSE:');
    log(
      DataCodec.jsonEncode(
        usersResponse.data,
      ),
    );
  } else {
    log('GET RESPONSE IS EMPTY');
  }

  // MAKING A POST REQUEST
  final requestBody = {
    'title': 'foo',
    'body': 'bar',
    'userId': 1,
  };

  final postResponse = await httpClient.post(
    Uri.parse(
      'https://jsonplaceholder.typicode.com/posts',
    ),
    requestBody: DataCodec.jsonEncode(requestBody),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  log('POST STATUS CODE: ${postResponse.statusCode}');

  if (postResponse.body.isNotEmpty) {
    log('POST RESPONSE:');
    log(
      DataCodec.jsonEncode(
        postResponse.data,
      ),
    );
  } else {
    log('POST RESPONSE IS EMPTY');
  }
}

```

## Additional information

If you like this package and find it usefull, please give it a like.

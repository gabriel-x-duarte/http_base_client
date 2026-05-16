A minimalistic and lightweight HTTP client for Dart and Flutter.

## Features

- Simple and easy-to-use HTTP request API
- Pure Dart package with no Flutter dependency
- Supports GET, POST, PUT, PATCH, and DELETE requests
- Lightweight and minimal architecture
- Easy to mock and test
- Compatible with Mobile, Desktop, and Web platforms
- Built-in internet connectivity checker
- Built-in JSON parsing helpers
- Supports both:
  - Auto-disposing HTTP clients
  - Persistent HTTP clients
- Includes `DataCodec` utility class for:
  - JSON encoding and decoding
  - UTF-8 encoding and decoding
  - Base64 encoding and decoding
  - Base64URL encoding and decoding

## HTTP Client Types

#### `HttpBaseClient`

Creates and closes a new underlying HTTP client
for each request.

Recommended for:
- Simple requests
- Occasional API calls
- Stateless usage

#### `PersistentHttpBaseClient`

Reuses the same underlying HTTP client instance
across multiple requests.

Recommended for:
- Multiple sequential requests
- Long-lived services
- Improved performance through connection reuse

`close()` must be called when the persistent client is no longer needed.

## Client-side Errors

When a request fails before receiving a valid HTTP response
(such as no internet connection or a socket exception),
the package returns:

- `statusCode = -1`
- `isClientSideError = true`

<br>

> **Note**
>
> Web browsers do not support direct `dart:io` socket connections.
>
> Because of this limitation,
> `checkInternetConnection` always returns `true`
> on Web platforms.
>
> For all other platforms (Mobile and Desktop),
> the socket-based connection check remains fully functional.

## Usage

```dart
import 'dart:developer';

import 'package:http_base_client/http_base_client.dart';

Future<void> main() async {
  // AUTO-DISPOSING HTTP CLIENT
  const httpClient = HttpBaseClient();

  // CHECKING INTERNET CONNECTIVITY
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

  // PERSISTENT HTTP CLIENT
  final persistentHttpClient = PersistentHttpBaseClient();

  final persistentClientResponse = await persistentHttpClient.get(
    Uri.parse(
      'https://jsonplaceholder.typicode.com/posts/1',
    ),
  );

  log(
    'PERSISTENT CLIENT STATUS CODE: '
    '${persistentClientResponse.statusCode}',
  );

  // CLOSING THE PERSISTENT CLIENT
  persistentHttpClient.close();

  log(
    'PERSISTENT CLIENT CLOSED: '
    '${persistentHttpClient.isClosed}',
  );
}

```

## Additional Information

If you find this package useful,
please consider giving it a like.

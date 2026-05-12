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

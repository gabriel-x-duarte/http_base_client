import 'package:flutter_test/flutter_test.dart';

import 'package:http_base_client/http_base_client.dart';

void main() {
  test('check internet connection', () async {
    bool internetConnection = await HttpBaseClient.checkInternetConnection;

    expect(internetConnection, true);
  });
}

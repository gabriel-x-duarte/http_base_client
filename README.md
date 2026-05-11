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

A minimalistic http client.
## Features

This package simplifies http requests, making it really easy and simple.

NOTE: Since dart:io and Socket connections are not supported in web browsers, the checkInternetConnection getter will ALWAYS return true when the code is compiled to JavaScript (Web). For all other platforms (Mobile and Desktop), the socket-based connection check remains fully functional.

## Usage

```dart
import 'package:flutter/material.dart';

import 'package:http_base_client/http_base_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _httpClient = const HttpBaseClient();

  String _data = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Press the button to fetch data',
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  _data,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchData,
        tooltip: 'fetch data',
        child: const Icon(Icons.download),
      ),
    );
  }

  Future _fetchData() async {
    // CHECK INTERNET CONNECTIVITY
    bool hasConnection = await _httpClient.checkInternetConnection;

    if (hasConnection) {
      /// MAKING A GET REQUEST
      var res = await _httpClient.get(
        Uri.parse("https://jsonplaceholder.typicode.com/users"),
      );

      if (res.body.isNotEmpty) {
        setState(() {
          _data = ObjectConverter.jsonEncode(
            ObjectConverter.jsonDecode(res.body),
          );
        });
      }

      await Future.delayed(const Duration(seconds: 3));

      /// MAKING A POST REQUEST
      Map<String, dynamic> requestBody = {
        "title": "foo",
        "body": "bar",
        "userId": 1,
      };

      var res2 = await _httpClient.post(
        Uri.parse("https://jsonplaceholder.typicode.com/posts"),
        requestBody: ObjectConverter.jsonEncode(requestBody),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      );

      if (res2.body.isNotEmpty) {
        setState(() {
          _data = ObjectConverter.jsonEncode(
            ObjectConverter.jsonDecode(res2.body),
          );
        });
      }
    }
  }
}

```

## Additional information

If you like this package and find it usefull, please give it a like.

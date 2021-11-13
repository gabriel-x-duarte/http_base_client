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

This package simplifys http requests, making it really easy and simple.

## Usage

```dart
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http_base_client/http_base_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Loading Overlay',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        onPressed: _fatchData,
        tooltip: 'fetch data',
        child: const Icon(Icons.download),
      ),
    );
  }

  Future _fatchData() async {
    /// CHECKING IF THERE IS INTERNET
    bool check = await HttpBaseClient.checkInternetConnection;

    if (check) {
      /// MAKKING A GET CALL
      var res = await HttpBaseClient.get(
          Uri.parse("https://jsonplaceholder.typicode.com/users"));

      setState(() {
        _data = jsonEncode(jsonDecode(res.payload));
      });
    }
  }
}

```

## Additional information

If you like this package and find it usefull, please give it a like.

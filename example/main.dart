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
      title: 'Test',
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
      /// MAKING A GET CALL
      var res = await HttpBaseClient.get(
          Uri.parse("https://jsonplaceholder.typicode.com/users"));

      setState(() {
        _data = jsonEncode(jsonDecode(res.payload));
      });

      await Future.delayed(const Duration(seconds: 3));

      /// MAKING A POST CALL
      Map<String, dynamic> _requestBody = {
        "title": "foo",
        "body": "bar",
        "userId": 1,
      };

      var res2 = await HttpBaseClient.post(
        Uri.parse("https://jsonplaceholder.typicode.com/posts"),
        requestBody: jsonEncode(_requestBody),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      );

      if (res2.payload.isNotEmpty) {
        setState(() {
          _data = jsonEncode(jsonDecode(res2.payload));
        });
      }
    }
  }
}

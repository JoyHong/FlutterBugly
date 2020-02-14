import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';

void main() async {
  FlutterBugly.postCatchedException(() => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: Ok'),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_video/pages/launcher.dart';


void main() => runApp(MainApp());


class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black
      ),
      home: LauncherFragment(),
      title: 'FlutterVideo',
    );
  }
}

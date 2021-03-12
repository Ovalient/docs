import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  static const String id = '/layoutPage/mainPage';
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메인'),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class EditContentPage extends StatefulWidget {
  static const String id = '/admin/editContent';
  EditContentPage({Key key}) : super(key: key);

  @override
  _EditContentPageState createState() => _EditContentPageState();
}

class _EditContentPageState extends State<EditContentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내용 관리'),
      ),
      body: Container(),
    );
  }
}

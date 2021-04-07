import 'package:flutter/material.dart';

class DeleteUserPage extends StatefulWidget {
  static const String id = '/admin/deleteUser';
  DeleteUserPage({Key key}) : super(key: key);

  @override
  _DeleteUserPageState createState() => _DeleteUserPageState();
}

class _DeleteUserPageState extends State<DeleteUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('사용자 삭제'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
      ),
    );
  }
}

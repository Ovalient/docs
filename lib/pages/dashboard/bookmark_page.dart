import 'package:flutter/material.dart';

class BookmarkPage extends StatefulWidget {
  static const String id = '/layoutPage/bookmarkPage';
  BookmarkPage({Key key}) : super(key: key);

  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('북마크'),
      ),
    );
  }
}

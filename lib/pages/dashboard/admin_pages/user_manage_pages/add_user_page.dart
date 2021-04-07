import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddUserPage extends StatefulWidget {
  static const String id = '/admin/addUser';
  AddUserPage({Key key}) : super(key: key);

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final firestore = FirebaseFirestore.instance;

  TextEditingController _emailController;
  TextEditingController _nameController;
  FocusNode _emailFocusNode;
  FocusNode _nameFocusNode;
  bool _isEditingEmail = false;
  bool _isEditingName = false;

  bool _isEmailExists = true;

  _checkEmailExists(String email) async {
    final result = await firestore
        .collection('user')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    List<QueryDocumentSnapshot> documents = result.docs;
    if (documents.length > 0)
      _isEmailExists = true;
    else
      _isEmailExists = false;
  }

  String _validateEmail(String value) {
    value = value.trim();

    if (value != null) {
      if (value.isEmpty) {
        return '필수 입력 항목입니다';
      } else if (!value.contains(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-_]+\.[a-zA-Z]+"))) {
        return '이메일 주소 형식이 아닙니다';
      } else if (_isEmailExists) {
        return '같은 이메일이 이미 존재합니다';
      }
    }
    return null;
  }

  String _validateText(String value) {
    if (value != null) {
      if (value.isEmpty) {
        return '필수 입력 항목입니다';
      }
    }
    return null;
  }

  Container editorWidget() => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('새로운 사용자 추가',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.0),
            TextField(
              textInputAction: TextInputAction.next,
              autofocus: true,
              style: TextStyle(color: Colors.black),
              controller: _emailController,
              focusNode: _emailFocusNode,
              onChanged: (value) async {
                await _checkEmailExists(value);
                setState(() {
                  _isEditingEmail = true;
                });
              },
              onSubmitted: (value) {
                _emailFocusNode.unfocus();
                FocusScope.of(context).requestFocus(_nameFocusNode);
              },
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.blueGrey[800],
                    width: 3,
                  ),
                ),
                filled: true,
                hintStyle: new TextStyle(
                  color: Colors.blueGrey[300],
                ),
                hintText: "사용자 이메일",
                fillColor: Colors.white,
                errorText: _isEditingEmail
                    ? _validateEmail(_emailController.text)
                    : null,
                errorStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.redAccent,
                ),
                suffixIcon: (_validateEmail(_emailController.text) != null)
                    ? Icon(Icons.clear, color: Colors.red[900])
                    : Icon(Icons.check, color: Colors.green),
              ),
            ),
            SizedBox(height: 10.0),
          ],
        ),
      );

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _emailController.text = null;
    _nameController.text = null;
    _emailFocusNode = FocusNode();
    _nameFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('사용자 추가'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
        child: editorWidget(),
      ),
    );
  }
}

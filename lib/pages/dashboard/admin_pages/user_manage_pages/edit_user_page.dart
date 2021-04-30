import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docs/utils/firebase_provider.dart';
import 'package:flutter/material.dart';

class EditUserPage extends StatefulWidget {
  static const String id = '/admin/editUser';
  EditUserPage({Key key}) : super(key: key);

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final firestore = FirebaseFirestore.instance;

  var userInfo;
  bool _isSelected = false;

  TextEditingController _emailController;
  TextEditingController _nameController;
  FocusNode _emailFocusNode;
  FocusNode _nameFocusNode;
  bool _isEditingEmail = false;
  bool _isEditingName = false;

  bool _isEmailExists = true;

  String _userRank = '일반';

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

  String _validateName(String value) {
    if (value != null) {
      if (value.isEmpty) {
        return '필수 입력 항목입니다';
      }
    }
    return null;
  }

  void signUpRequest() async {
    if (_validateEmail(_emailController.text) == null &&
        _validateName(_nameController.text) == null) {
      await signUp(
              username: _nameController.text.trim(),
              email: _emailController.text.trim(),
              password: 'dan3167',
              rank: _userRank)
          .then((result) async {
        if (result == null) {
          createSnackBar('계정 생성이 완료되었습니다');
          setState(() {
            _emailController = TextEditingController();
            _nameController = TextEditingController();
            _emailController.text = null;
            _nameController.text = null;
            _emailFocusNode = FocusNode();
            _nameFocusNode = FocusNode();
            _isEditingEmail = false;
            _isEditingName = false;
            _isEmailExists = true;
            _userRank = '일반';
          });
        } else {
          createSnackBar(result);
        }
      });
    } else {
      createSnackBar('사용자 이메일, 사용자 이름을 입력해주세요');
    }
  }

  createSnackBar(String message) {
    final snackBar = new SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  SingleChildScrollView editorWidget() => SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('새로운 사용자 추가',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 20.0),
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
            TextField(
              textInputAction: TextInputAction.next,
              style: TextStyle(color: Colors.black),
              controller: _nameController,
              focusNode: _nameFocusNode,
              onChanged: (value) async {
                await _checkEmailExists(value);
                setState(() {
                  _isEditingName = true;
                });
              },
              onSubmitted: (value) {
                _nameFocusNode.unfocus();
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
                hintText: "사용자 이름",
                fillColor: Colors.white,
                errorText:
                    _isEditingName ? _validateName(_nameController.text) : null,
                errorStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.redAccent,
                ),
                suffixIcon: (_validateName(_nameController.text) != null)
                    ? Icon(Icons.clear, color: Colors.red[900])
                    : Icon(Icons.check, color: Colors.green),
              ),
            ),
            SizedBox(height: 5.0),
            Row(
              children: [
                Text('사용자 권한'),
                SizedBox(width: 10.0),
                DropdownButton(
                  value: _userRank,
                  onChanged: (value) {
                    setState(() {
                      _userRank = value;
                    });
                  },
                  items: ['일반', '관리자'].map<DropdownMenuItem>((value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 5.0),
            SizedBox(height: 15.0),
            Text('기본 비밀번호는 \'dan3167\'입니다'),
            SizedBox(height: 15.0),
            Container(
              alignment: Alignment.centerRight,
              child: MaterialButton(
                elevation: 0,
                minWidth: 200,
                height: 50,
                onPressed: (_validateEmail(_emailController.text) == null &&
                        _validateName(_nameController.text) == null)
                    ? () {
                        setState(() {
                          _emailFocusNode.unfocus();
                          _nameFocusNode.unfocus();
                        });
                        signUpRequest();
                      }
                    : null,
                color: Theme.of(context).accentColor,
                disabledColor: Colors.grey[350],
                child: Text('확인',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                textColor: Colors.white,
              ),
            ),
            SizedBox(height: 20.0),
            Divider(),
            SizedBox(height: 20.0),
            Text('사용자 활성화 / 비활성화',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 20.0),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: Text('• 계정 삭제는 Google Firebase 콘솔에서만 가능합니다.',
                    style: TextStyle(color: Colors.red))),
            SizedBox(height: 20.0),
            Row(children: [
              Expanded(
                  flex: 1,
                  child: Text('이름',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              userInfo != null
                  ? Expanded(flex: 4, child: Text(userInfo.data()['userName']))
                  : Container(),
            ]),
            SizedBox(height: 10.0),
            Row(children: [
              Expanded(
                  flex: 1,
                  child: Text('이메일',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              userInfo != null
                  ? Expanded(flex: 4, child: Text(userInfo.data()['email']))
                  : Container(),
            ]),
            SizedBox(height: 10.0),
            Row(children: [
              Expanded(
                  flex: 1,
                  child: Text('권한',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              userInfo != null
                  ? Expanded(flex: 4, child: Text(userInfo.data()['rank']))
                  : Container(),
            ]),
            SizedBox(height: 10.0),
            Row(children: [
              Expanded(
                  flex: 1,
                  child: Text('상태',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              userInfo != null
                  ? Expanded(
                      flex: 4,
                      child: Text(userInfo.data()['enabled'] ? '활성화' : '비활성화'))
                  : Container(),
            ]),
            SizedBox(height: 20.0),
            Container(
              alignment: Alignment.centerRight,
              child: MaterialButton(
                elevation: 0,
                minWidth: 200,
                height: 50,
                onPressed: _isSelected && userInfo != null
                    ? () async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Row(
                                  children: <Widget>[
                                    Icon(Icons.report_problem,
                                        color: Colors.red),
                                    SizedBox(width: 10.0),
                                    Text('사용자 활성화 / 비활성화',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w900)),
                                  ],
                                ),
                                content: Text(
                                    '비활성화 된 계정은 로그인을 할 수 없습니다.\n그래도 진행하시겠습니까?'),
                                actions: [
                                  MaterialButton(
                                    onPressed: () async {
                                      await firestore
                                          .collection('user')
                                          .doc(userInfo.id)
                                          .update({
                                        'enabled': !userInfo.data()['enabled']
                                      });
                                      createSnackBar('사용자 상태가 변경되었습니다.');
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK'),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'),
                                  )
                                ],
                              );
                            });
                      }
                    : null,
                color: Colors.red,
                disabledColor: Colors.grey[350],
                child: Text('활성화 / 비활성화',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                textColor: Colors.white,
              ),
            ),
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
        title: Text('사용자 관리'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: StreamBuilder(
                          stream: firestore
                              .collection('user')
                              .orderBy('userName')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  child: Center(
                                      child: CircularProgressIndicator()));

                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _isSelected = true;
                                        });
                                        userInfo = snapshot.data.docs[index];
                                      },
                                      child: ListTile(
                                        leading: snapshot.data.docs[index]
                                                .data()['enabled']
                                            ? Icon(Icons.check_circle,
                                                size: 32.0, color: Colors.green)
                                            : Icon(Icons.remove_circle,
                                                size: 32.0, color: Colors.red),
                                        title: Text.rich(
                                          TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: snapshot.data.docs[index]
                                                    .data()['userName'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text: ' | ',
                                              ),
                                              TextSpan(
                                                text: snapshot.data.docs[index]
                                                    .data()['email'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        subtitle:
                                            Text(snapshot.data.docs[index].id),
                                        trailing: Text(snapshot.data.docs[index]
                                            .data()['rank']),
                                      ),
                                    ),
                                  );
                                });
                          }),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(flex: 1, child: editorWidget())
          ],
        ),
      ),
    );
  }
}

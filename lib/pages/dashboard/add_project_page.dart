import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docs/models/model.dart';
import 'package:docs/pages/dashboard_page.dart';
import 'package:docs/utils/firebase_provider.dart';
import 'package:flutter/material.dart';

class AddProjectPage extends StatefulWidget {
  AddProjectPage({Key key}) : super(key: key);

  @override
  _AddProjectPageState createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final firestore = FirebaseFirestore.instance;

  String _companyName;
  String _factoryName;

  TextEditingController _numController;
  TextEditingController _titleController;
  FocusNode _numFocusNode;
  FocusNode _titleFocusNode;
  bool _isEditingNum = false;
  bool _isEditingTitle = false;

  bool _isFactorySelected = false;

  String _validateText(String value) {
    if (value != null) {
      if (value.isEmpty) {
        return '필수 입력 항목입니다';
      }
    }
    return null;
  }

  Future<void> _uploading() async {
    final number = _numController.text;
    final title = _titleController.text;
    final date = DateTime.now();

    try {
      await firestore.collection('board').doc(number).set({
        'projectNum': number,
        'companyName': _companyName,
        'factoryName': _factoryName,
        'title': title,
        'date': date,
        'manager': '미정',
        'views': 0,
      });
      createSnackBar('새 프로젝트가 등록되었습니다');
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }
    onTabNavigate(3);
    selectedReport = Report(
        projectNum: number,
        companyName: _companyName,
        factoryName: _factoryName,
        title: title,
        date: Timestamp.fromDate(date),
        manager: '미정',
        views: 0);
  }

  createSnackBar(String message) {
    final snackBar = new SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Container editorWidget() => Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: 130.0,
                  child: Text('CUSTOMER',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                ),
                StreamBuilder(
                  stream: firestore.collection('factory').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<DropdownMenuItem> currentItems = [];

                      snapshot.data.docs.forEach((doc) {
                        currentItems.add(
                          DropdownMenuItem(
                            child: Text(
                              doc.id,
                            ),
                            value: "${doc.id}",
                          ),
                        );
                      });

                      currentItems.sort((a, b) {
                        return b.value.compareTo(a.value);
                      });

                      return DropdownButton(
                        hint: Text('제조사'),
                        items: currentItems,
                        onChanged: (value) {
                          setState(() {
                            if (_isFactorySelected) {
                              _isFactorySelected = false;
                              _factoryName = null;
                            }
                            _companyName = value;
                          });
                        },
                        value: _companyName,
                        isExpanded: false,
                      );
                    } else
                      return DropdownButton(hint: Text('제조사'));
                  },
                ),
                SizedBox(width: 10.0),
                (_companyName != null)
                    ? StreamBuilder(
                        stream: firestore
                            .collection('factory')
                            .doc(_companyName)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<DropdownMenuItem> currentItems = [];

                            snapshot.data['name'].forEach((element) {
                              currentItems.add(
                                DropdownMenuItem(
                                  child: Text(element),
                                  value: "$element",
                                ),
                              );
                            });

                            currentItems.sort((a, b) {
                              return a.value.compareTo(b.value);
                            });

                            return DropdownButton(
                              hint: Text('사이트'),
                              items: currentItems,
                              onChanged: (value) {
                                setState(() {
                                  _factoryName = value;
                                  _isFactorySelected = true;
                                });
                              },
                              value: _factoryName,
                              isExpanded: false,
                            );
                          } else
                            return DropdownButton(hint: Text('사이트'));
                        },
                      )
                    : SizedBox(),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              textInputAction: TextInputAction.next,
              autofocus: true,
              style: TextStyle(color: Colors.black),
              controller: _numController,
              focusNode: _numFocusNode,
              onChanged: (value) {
                setState(() {
                  _isEditingNum = true;
                });
              },
              onSubmitted: (value) {
                _numFocusNode.unfocus();
                FocusScope.of(context).requestFocus(_titleFocusNode);
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
                hintText: "프로젝트 번호",
                fillColor: Colors.white,
                errorText:
                    _isEditingNum ? _validateText(_numController.text) : null,
                errorStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.redAccent,
                ),
              ),
            ),
            SizedBox(height: 5),
            Divider(thickness: 0.3, color: Colors.black),
            SizedBox(height: 5),
            TextField(
              textInputAction: TextInputAction.next,
              autofocus: true,
              style: TextStyle(color: Colors.black),
              controller: _titleController,
              focusNode: _titleFocusNode,
              onChanged: (value) {
                setState(() {
                  _isEditingTitle = true;
                });
              },
              onSubmitted: (value) async {
                _titleFocusNode.unfocus();
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('알림'),
                      content: Text('프로젝트를 생성 하시겠습니까?'),
                      actions: [
                        MaterialButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _uploading();
                          },
                        ),
                        MaterialButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
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
                hintText: "프로젝트 명",
                fillColor: Colors.white,
                errorText: _isEditingTitle
                    ? _validateText(_titleController.text)
                    : null,
                errorStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.redAccent,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            MaterialButton(
              elevation: 0,
              minWidth: double.maxFinite,
              height: 60.0,
              onPressed: (_validateText(_numController.text) == null &&
                      _validateText(_titleController.text) == null &&
                      _companyName != null &&
                      _factoryName != null)
                  ? () async {
                      setState(() {
                        _numFocusNode.unfocus();
                        _titleFocusNode.unfocus();
                      });
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('알림'),
                            content: Text('프로젝트를 생성 하시겠습니까?'),
                            actions: [
                              MaterialButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _uploading();
                                },
                              ),
                              MaterialButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  : null,
              color: Theme.of(context).accentColor,
              disabledColor: Colors.grey[350],
              child: Text('등록',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              textColor: Colors.white,
            ),
          ],
        ),
      );

  @override
  void initState() {
    super.initState();
    _numController = TextEditingController();
    _titleController = TextEditingController();
    _numController.text = null;
    _titleController.text = null;
    _numFocusNode = FocusNode();
    _titleFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            onTabNavigate(1);
          },
        ),
        title: Text('새 프로젝트 추가'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
        child: userRank == '관리자'
            ? editorWidget()
            : Center(child: Text('이 계정은 게시물 작성 권한이 없습니다.')),
      ),
    );
  }
}

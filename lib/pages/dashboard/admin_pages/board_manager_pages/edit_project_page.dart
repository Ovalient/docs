import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docs/models/model.dart';
import 'package:docs/widgets/company_icons.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class EditProjectPage extends StatefulWidget {
  static const String id = '/admin/editProject';
  EditProjectPage({Key key}) : super(key: key);

  @override
  _EditProjectPageState createState() => _EditProjectPageState();
}

class _EditProjectPageState extends State<EditProjectPage> {
  final firestore = FirebaseFirestore.instance;

  var report;
  bool _isSelected = false;

  bool _isEditingTitle = false;

  String _validateTitle(String value) {
    value = value.trim();

    if (value != null) {
      if (value.isEmpty) {
        return '필수 입력 항목입니다';
      }
    }
    return null;
  }

  createSnackBar(String message) {
    final snackBar = new SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  getCompanyIcon(String name) {
    Widget icon;

    switch (name) {
      case '기아':
        icon = Icon(CompanyIcons.kia, color: Colors.redAccent, size: 30.0);
        break;
      case '현대':
        icon = Icon(CompanyIcons.hyundai, color: Colors.blue, size: 30.0);
        break;
      default:
        icon = Icon(Icons.keyboard_control, size: 30.0);
        break;
    }
    return icon;
  }

  SingleChildScrollView editorWidget() => SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('프로젝트 정보 관리',
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
                child: Text(
                    '• 프로젝트 번호는 고유 값이므로 수정이 불가능합니다.\n     삭제 후 재등록이 필요합니다.',
                    style: TextStyle(color: Colors.red))),
            SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text('프로젝트 번호',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                report != null
                    ? Expanded(
                        flex: 4, child: Text(report.data()['projectNum']))
                    : Container(),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text('프로젝트 명',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                report != null
                    ? Expanded(flex: 4, child: Text(report.data()['title']))
                    : Container(),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text('고객사',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                report != null
                    ? Expanded(
                        flex: 4, child: Text(report.data()['companyName']))
                    : Container(),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text('사이트',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                report != null
                    ? Expanded(
                        flex: 4, child: Text(report.data()['factoryName']))
                    : Container(),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: MaterialButton(
                    elevation: 0,
                    height: 50,
                    onPressed: _isSelected && report != null
                        ? () async {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                TextEditingController titleController =
                                    TextEditingController();

                                FocusNode titleFocusNode = FocusNode();

                                String companyName =
                                    report.data()['companyName'];
                                String factoryName =
                                    report.data()['factoryName'];

                                bool _isFactorySelected = true;

                                titleController.text = report.data()['title'];

                                return AlertDialog(
                                  title: Text('프로젝트 정보 수정',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900)),
                                  content: StatefulBuilder(
                                    builder: (context, subSetState) {
                                      return SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            SizedBox(height: 20.0),
                                            Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 14.0,
                                                    vertical: 14.0),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.red,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          0.0),
                                                ),
                                                child: Text(
                                                    '• 프로젝트 번호는 고유 값이므로 수정이 불가능합니다.\n     삭제 후 재등록이 필요합니다.',
                                                    style: TextStyle(
                                                        color: Colors.red))),
                                            SizedBox(height: 20.0),
                                            IntrinsicHeight(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      height: 50,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text('프로젝트 명',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                  ),
                                                  SizedBox(width: 20.0),
                                                  Expanded(
                                                    flex: 3,
                                                    child: TextField(
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      autofocus: true,
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      controller:
                                                          titleController,
                                                      focusNode: titleFocusNode,
                                                      onChanged: (value) async {
                                                        setState(() {
                                                          _isEditingTitle =
                                                              true;
                                                        });
                                                      },
                                                      onSubmitted:
                                                          (value) async {
                                                        titleFocusNode
                                                            .unfocus();
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            new OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors
                                                                .blueGrey[800],
                                                            width: 3,
                                                          ),
                                                        ),
                                                        filled: true,
                                                        hintStyle:
                                                            new TextStyle(
                                                          color: Colors
                                                              .blueGrey[300],
                                                        ),
                                                        hintText: "프로젝트 명",
                                                        fillColor: Colors.white,
                                                        errorText: _isEditingTitle
                                                            ? _validateTitle(
                                                                titleController
                                                                    .text)
                                                            : null,
                                                        errorStyle: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Colors.redAccent,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10.0),
                                            IntrinsicHeight(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      height: 50,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text('고객사',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                  ),
                                                  StreamBuilder(
                                                    stream: firestore
                                                        .collection('factory')
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        List<DropdownMenuItem>
                                                            currentItems = [];

                                                        snapshot.data.docs
                                                            .forEach((doc) {
                                                          currentItems.add(
                                                            DropdownMenuItem(
                                                              child: Text(
                                                                doc.id,
                                                              ),
                                                              value:
                                                                  "${doc.id}",
                                                            ),
                                                          );
                                                        });

                                                        currentItems
                                                            .sort((a, b) {
                                                          return b.value
                                                              .compareTo(
                                                                  a.value);
                                                        });

                                                        return DropdownButton(
                                                          hint: Text('제조사'),
                                                          items: currentItems,
                                                          onChanged: (value) {
                                                            subSetState(() {
                                                              if (_isFactorySelected) {
                                                                _isFactorySelected =
                                                                    false;
                                                                factoryName =
                                                                    null;
                                                              }
                                                              companyName =
                                                                  value;
                                                            });
                                                          },
                                                          value: companyName,
                                                          isExpanded: false,
                                                        );
                                                      } else
                                                        return DropdownButton(
                                                            hint: Text('제조사'));
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10.0),
                                            (companyName != null)
                                                ? IntrinsicHeight(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            height: 50,
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text('사이트',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                        ),
                                                        StreamBuilder(
                                                          stream: firestore
                                                              .collection(
                                                                  'factory')
                                                              .doc(companyName)
                                                              .snapshots(),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                .hasData) {
                                                              List<DropdownMenuItem>
                                                                  currentItems =
                                                                  [];

                                                              snapshot
                                                                  .data['name']
                                                                  .forEach(
                                                                      (element) {
                                                                currentItems
                                                                    .add(
                                                                  DropdownMenuItem(
                                                                    child: Text(
                                                                        element),
                                                                    value:
                                                                        "$element",
                                                                  ),
                                                                );
                                                              });

                                                              currentItems
                                                                  .sort((a, b) {
                                                                return a.value
                                                                    .compareTo(b
                                                                        .value);
                                                              });

                                                              return DropdownButton(
                                                                hint:
                                                                    Text('사이트'),
                                                                items:
                                                                    currentItems,
                                                                onChanged:
                                                                    (value) {
                                                                  subSetState(
                                                                      () {
                                                                    factoryName =
                                                                        value;
                                                                    _isFactorySelected =
                                                                        true;
                                                                  });
                                                                },
                                                                value:
                                                                    factoryName,
                                                                isExpanded:
                                                                    false,
                                                              );
                                                            } else
                                                              return DropdownButton(
                                                                  hint: Text(
                                                                      '사이트'));
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox(),
                                            SizedBox(height: 20.0),
                                            MaterialButton(
                                              elevation: 0,
                                              height: 50,
                                              onPressed: _validateTitle(
                                                              titleController
                                                                  .text) ==
                                                          null &&
                                                      companyName != null &&
                                                      factoryName != null
                                                  ? () async {
                                                      await firestore
                                                          .collection('board')
                                                          .doc(report.data()[
                                                              'projectNum'])
                                                          .update({
                                                        'title': titleController
                                                            .text,
                                                        'companyName':
                                                            companyName,
                                                        'factoryName':
                                                            factoryName,
                                                      });
                                                      Navigator.pop(context);
                                                      setState(() {
                                                        report = null;
                                                      });
                                                      createSnackBar(
                                                          '사용자 상태가 변경되었습니다.');
                                                    }
                                                  : null,
                                              color:
                                                  Theme.of(context).accentColor,
                                              disabledColor: Colors.grey[350],
                                              child: Text('변경',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16)),
                                              textColor: Colors.white,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          }
                        : null,
                    color: Theme.of(context).accentColor,
                    disabledColor: Colors.grey[350],
                    child: Text('수정',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(width: 50.0),
                Expanded(
                  flex: 1,
                  child: MaterialButton(
                    elevation: 0,
                    height: 50,
                    onPressed: _isSelected && report != null
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
                                      Text('프로젝트 삭제',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w900)),
                                    ],
                                  ),
                                  content: Text(
                                      '삭제 된 프로젝트는 복구가 불가능합니다.\n그래도 진행하시겠습니까?'),
                                  actions: [
                                    MaterialButton(
                                      onPressed: () async {
                                        await firestore
                                            .collection('board')
                                            .doc(report.data()['projectNum'])
                                            .delete();
                                        createSnackBar('프로젝트가 삭제되었습니다.');
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
                              },
                            );
                          }
                        : null,
                    color: Colors.red,
                    disabledColor: Colors.grey[350],
                    child: Text('삭제',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    textColor: Colors.white,
                  ),
                )
              ],
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('프로젝트 관리'),
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
                      child: PaginateFirestore(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemsPerPage: 12,
                          query: firestore
                              .collection('board')
                              .orderBy('date', descending: true),
                          isLive: true,
                          itemBuilderType: PaginateBuilderType.listView,
                          itemBuilder: (index, context, snapshot) {
                            return Card(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _isSelected = true;
                                    report = snapshot;
                                  });
                                },
                                child: ListTile(
                                  title: Text.rich(
                                    TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: snapshot.data()['factoryName'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: ' | ',
                                        ),
                                        TextSpan(
                                          text: snapshot.data()['title'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  subtitle: Text(snapshot.data()['projectNum']),
                                  leading: getCompanyIcon(
                                      snapshot.data()['companyName']),
                                ),
                              ),
                            );
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

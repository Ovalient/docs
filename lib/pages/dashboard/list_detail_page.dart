import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docs/models/model.dart';
import 'package:docs/pages/dashboard_page.dart';
import 'package:docs/utils/firebase_provider.dart';
import 'package:docs/widgets/company_icons.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

class ListDetailPage extends StatefulWidget {
  static const String id = '/dashboard/detail';
  ListDetailPage({Key key}) : super(key: key);

  @override
  _ListDetailPageState createState() => _ListDetailPageState();
}

class _ListDetailPageState extends State<ListDetailPage> {
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  List<int> _selectedFile;
  Uint8List _bytesData;
  String fileName;

  bool _importance;
  bool _kickoff;

  String category;
  bool _isCategorySelected;
  String projectManager;

  TextEditingController textControllerContents;
  FocusNode textFocusNodeContents;

  @override
  void initState() {
    super.initState();

    _importance = false;
    _kickoff = false;
    category = null;
    _isCategorySelected = false;
    projectManager = null;

    textControllerContents = TextEditingController();
    textControllerContents.text = null;
    textFocusNodeContents = FocusNode();
  }

  editAttachmentDialog(BuildContext context, Contents selectedContent) {
    List<Uint8List> _bytesFiles = [];
    List<html.File> _files = [];

    bool _isAttached = false;

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('첨부 파일 추가', style: TextStyle(fontWeight: FontWeight.w900)),
          MaterialButton(
            height: 30.0,
            minWidth: 30.0,
            child: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.6,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    child: Text(
                      '기존 첨부 파일',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  FutureBuilder(
                    future: storage
                        .ref(
                            '${selectedReport.companyName}/${selectedReport.factoryName}/${selectedReport.projectNum}/${selectedContent.category}/${DateFormat().format(selectedContent.date.toDate())}')
                        .listAll(),
                    builder: (context, snapshot) {
                      List<Reference> _fileList = [];

                      if (!snapshot.hasData) return SizedBox();

                      for (var element in snapshot.data.items) {
                        _fileList.add(element);
                      }

                      return Container(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: (_fileList != null && _fileList.isNotEmpty)
                              ? _fileList.length
                              : 0,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: AutoSizeText(
                                    _fileList[index].name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 5.0),
                  Divider(),
                  SizedBox(height: 5.0),
                  SizedBox(
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '추가할 첨부 파일',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                flex: 4,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: 50.0,
                                    maxHeight: 300.0,
                                    minWidth: double.infinity,
                                  ),
                                  child: (_files.length > 0)
                                      ? Scrollbar(
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            itemCount: (_files != null &&
                                                    _files.isNotEmpty)
                                                ? _files.length
                                                : 1,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: AutoSizeText(
                                                      _files[index].name,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  SizedBox(width: 5.0),
                                                  MaterialButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _files.removeAt(index);
                                                      });
                                                    },
                                                    child: Text("×"),
                                                  )
                                                ],
                                              );
                                            },
                                            separatorBuilder:
                                                (BuildContext context,
                                                        int index) =>
                                                    const Divider(),
                                          ),
                                        )
                                      : SizedBox(),
                                ),
                              ),
                              SizedBox(width: 10.0),
                              ButtonTheme(
                                minWidth: 160.0,
                                height: 50.0,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    html.InputElement uploadInput =
                                        html.FileUploadInputElement();
                                    uploadInput.multiple = true;
                                    uploadInput.draggable = true;
                                    uploadInput.click();

                                    uploadInput.onChange.listen((e) {
                                      final files = uploadInput.files;
                                      //final file = files[0];

                                      files.forEach((element) {
                                        final reader = new html.FileReader();
                                        reader.onLoadEnd.listen((e) {
                                          setState(() {
                                            _bytesData = Base64Decoder()
                                                .convert(reader.result
                                                    .toString()
                                                    .split(",")
                                                    .last);
                                            _selectedFile = _bytesData;
                                          });
                                          setState(() {
                                            _files.add(element);
                                            _isAttached = true;
                                          });
                                        });
                                        reader.readAsDataUrl(element);
                                      });
                                    });
                                  },
                                  child: Text(
                                    "파일 첨부",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        onPressed: (_isAttached)
                            ? () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext childContext) {
                                    return AlertDialog(
                                      title: Text('알림'),
                                      content: Text('첨부 파일을 추가하시겠습니까?'),
                                      actions: [
                                        MaterialButton(
                                          child: Text('OK'),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            Navigator.of(childContext).pop();
                                            await addAttachment(
                                                _files, selectedContent);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            : null,
                        child: Icon(Icons.save),
                        backgroundColor:
                            (_isAttached) ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  addContentsDialog(BuildContext context) {
    List<Uint8List> _bytesFiles = [];
    List<html.File> _files = [];

    bool _isAttached = false;
    bool _isEditing = false;

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('새 내용 추가', style: TextStyle(fontWeight: FontWeight.w900)),
          MaterialButton(
            height: 30.0,
            minWidth: 30.0,
            child: Icon(Icons.close),
            onPressed: () {
              if (_isEditing || _isCategorySelected || _isAttached) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext childContext) {
                    return AlertDialog(
                      title: Row(
                        children: <Widget>[
                          Icon(Icons.report_problem),
                          SizedBox(width: 10.0),
                          Text('작성중인 글이 있습니다',
                              style: TextStyle(fontWeight: FontWeight.w900)),
                        ],
                      ),
                      content: Text('정말 작업을 그만두겠습니까?'),
                      actions: [
                        MaterialButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(childContext).pop();

                              setState(() {
                                _bytesFiles = [];
                                _files = [];

                                _importance = false;
                                _kickoff = false;
                                category = null;
                                _isCategorySelected = false;
                                projectManager = null;

                                textControllerContents =
                                    TextEditingController();
                                textControllerContents.text = null;
                                textFocusNodeContents = FocusNode();
                              });
                            },
                            child: Text('OK')),
                        MaterialButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel')),
                      ],
                    );
                  },
                );
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          setState(() {});

          return Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.6,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Checkbox(
                        activeColor: Colors.red,
                        value: _importance,
                        onChanged: (value) {
                          setState(() {
                            _importance = value;
                          });
                        },
                      ),
                      Text('중요'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 120.0,
                        child: Text('등록 유형', style: TextStyle(fontSize: 20.0)),
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('category')
                            .doc('FqnVsuezYynSLSwOCcAX')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<DropdownMenuItem> currentItems = [];

                            snapshot.data['category'].forEach((element) {
                              currentItems.add(
                                DropdownMenuItem(
                                  child: Text(element),
                                  value: "$element",
                                ),
                              );
                            });

                            return DropdownButton(
                              hint: Text('등록 유형'),
                              items: currentItems,
                              onChanged: (value) {
                                setState(() {
                                  category = value;
                                  _isCategorySelected = true;
                                  if (value == '킥어프-영업') {
                                    _kickoff = true;
                                  } else {
                                    _kickoff = false;
                                  }
                                });
                              },
                              value: category,
                              isExpanded: false,
                            );
                          } else
                            return DropdownButton(
                              hint: Text('등록 유형'),
                            );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  (_kickoff)
                      ? Container(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 120.0,
                                child: Text('PM',
                                    style: TextStyle(fontSize: 20.0)),
                              ),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('user')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List<DropdownMenuItem> currentItems = [];

                                    snapshot.data.docs.forEach((element) {
                                      currentItems.add(
                                        DropdownMenuItem(
                                          child: Text(element['userName']),
                                          value: "${element['userName']}",
                                        ),
                                      );
                                    });

                                    return DropdownButton(
                                      hint: Text('PM'),
                                      items: currentItems,
                                      onChanged: (value) {
                                        setState(() {
                                          projectManager = value;
                                        });
                                      },
                                      value: projectManager,
                                      isExpanded: false,
                                    );
                                  } else
                                    return DropdownButton(
                                      hint: Text('PM'),
                                    );
                                },
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Container(
                    height: 200,
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      expands: true,
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: TextStyle(color: Colors.black),
                      controller: textControllerContents,
                      onChanged: (value) {
                        setState(() {
                          _isEditing = true;
                        });
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
                        hintText: "내용",
                        fillColor: Colors.white,
                        errorText: _isEditing
                            ? _validateContents(textControllerContents.text)
                            : null,
                        errorStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Divider(thickness: 0.3, color: Colors.black),
                  SizedBox(height: 5),
                  SizedBox(
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "첨부자료",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                flex: 4,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: 50.0,
                                    maxHeight: 300.0,
                                    minWidth: double.infinity,
                                  ),
                                  child: (_files.length > 0)
                                      ? Scrollbar(
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            itemCount: (_files != null &&
                                                    _files.isNotEmpty)
                                                ? _files.length
                                                : 1,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: AutoSizeText(
                                                      _files[index].name,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  SizedBox(width: 5.0),
                                                  MaterialButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _files.removeAt(index);
                                                      });
                                                    },
                                                    child: Text("×"),
                                                  )
                                                ],
                                              );
                                            },
                                            separatorBuilder:
                                                (BuildContext context,
                                                        int index) =>
                                                    const Divider(),
                                          ),
                                        )
                                      : SizedBox(),
                                ),
                              ),
                              SizedBox(width: 10.0),
                              ButtonTheme(
                                minWidth: 160.0,
                                height: 50.0,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    html.InputElement uploadInput =
                                        html.FileUploadInputElement();
                                    uploadInput.multiple = true;
                                    uploadInput.draggable = true;
                                    uploadInput.click();

                                    uploadInput.onChange.listen((e) {
                                      final files = uploadInput.files;
                                      //final file = files[0];

                                      files.forEach((element) {
                                        final reader = new html.FileReader();
                                        reader.onLoadEnd.listen((e) {
                                          setState(() {
                                            _bytesData = Base64Decoder()
                                                .convert(reader.result
                                                    .toString()
                                                    .split(",")
                                                    .last);
                                            _selectedFile = _bytesData;
                                          });
                                          setState(() {
                                            _files.add(element);
                                            _isAttached = true;
                                            print(element);
                                          });
                                        });
                                        reader.readAsDataUrl(element);
                                      });
                                    });
                                  },
                                  child: Text(
                                    "파일 첨부",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        onPressed: (_isEditing && _isCategorySelected)
                            ? () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext childContext) {
                                    return AlertDialog(
                                      title: Text('알림'),
                                      content: Text('내용을 추가하시겠습니까?'),
                                      actions: [
                                        MaterialButton(
                                          child: Text('OK'),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            Navigator.of(childContext).pop();
                                            await uploadToStorage(
                                                _files, projectManager);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            : null,
                        child: Icon(Icons.save),
                        backgroundColor: (_isEditing && _isCategorySelected)
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _validateContents(String value) {
    if (value != null) {
      if (value.isEmpty) {
        return '내용을 입력하세요';
      }
    }
    return null;
  }

  Future<void> uploadToStorage(List<html.File> files, projectManager) async {
    final dateTime = DateTime.now();
    final stringDate = DateFormat().format(DateTime.now());
    final companyName = selectedReport.companyName;
    final factoryName = selectedReport.factoryName;
    final projectNum = selectedReport.projectNum;
    final contents = textControllerContents.text;

    List<UploadTask> tasks = [];

    try {
      if (files != null) {
        files.forEach((html.File element) async {
          final fileName = element.name;
          final path =
              '$companyName/$factoryName/$projectNum/$category/$stringDate/$fileName';
          var task = storage.ref().child(path).putBlob(element);

          tasks.add(task);
          print(fileName);
        });
      }
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: 1.0,
                  child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white)),
                ),
              ],
            );
          });
      if (projectManager != null) {
        String uid;
        await firestore
            .collection('user')
            .where('userName', isEqualTo: projectManager)
            .get()
            .then((value) {
          value.docs.forEach((element) {
            uid = element.id;
          });
        });
        await firestore.collection('board').doc(projectNum).update({
          'projectNum': selectedReport.projectNum,
          'companyName': selectedReport.companyName,
          'factoryName': selectedReport.factoryName,
          'title': selectedReport.title,
          'date': Timestamp.fromDate(dateTime),
          'manager': uid,
          'views': 0,
        });
      } else {
        await firestore.collection('board').doc(projectNum).update({
          'projectNum': selectedReport.projectNum,
          'companyName': selectedReport.companyName,
          'factoryName': selectedReport.factoryName,
          'title': selectedReport.title,
          'date': Timestamp.fromDate(dateTime),
          'manager': '미정',
          'views': 0,
        });
      }
      await firestore
          .collection('board')
          .doc(projectNum)
          .collection('contents')
          .add({
        'importance': _importance,
        'category': category,
        'contents': contents,
        'date': Timestamp.fromDate(dateTime),
        'email': userEmail,
        'userName': userName,
      });
      await firestore.collection('recent').add({
        'recent':
            '$factoryName | $projectNum | ${selectedReport.title} | $category',
        'date': DateTime.now(),
      });
      for (var element in tasks) {
        element.snapshotEvents.listen((snapshot) {
          print(
              'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
        });
        await element;
      }

      if (_importance) await sendEmail(stringDate);
      Navigator.of(context).pop();

      setState(() {});

      createSnackBar('내용 추가가 완료되었습니다');
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }
  }

  Future<void> addAttachment(
      List<html.File> files, Contents selectedContent) async {
    final companyName = selectedReport.companyName;
    final factoryName = selectedReport.factoryName;
    final projectNum = selectedReport.projectNum;

    List<UploadTask> tasks = [];

    try {
      if (files != null) {
        files.forEach((html.File element) async {
          final fileName = element.name;
          final path =
              '$companyName/$factoryName/$projectNum/${selectedContent.category}/${DateFormat().format(selectedContent.date.toDate())}/$fileName';
          var task = storage.ref().child(path).putBlob(element);

          tasks.add(task);
        });
      }
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: 1.0,
                  child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white)),
                ),
              ],
            );
          });
      for (var element in tasks) {
        element.snapshotEvents.listen((snapshot) {
          print(
              'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
        });
        await element;
      }
      Navigator.of(context).pop();

      setState(() {});

      createSnackBar('첨부 파일 추가가 완료되었습니다');
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }
  }

  sendEmail(String dateTime) async {
    String _emails = '';
    String _fileList = '';

    await firestore.collection('user').where('email').get().then((doc) {
      doc.docs.forEach((element) {
        _emails += '${element.data()['email']},';
      });
    });

    var snapshot = await storage
        .ref(
            '${selectedReport.companyName}/${selectedReport.factoryName}/${selectedReport.projectNum}/$category/$dateTime')
        .listAll();

    for (var element in snapshot.items) {
      String downloadURL = await storage.ref(element.fullPath).getDownloadURL();
      print('DOWNLOAD URL -----\nURL: $downloadURL');

      http.Response response = await http.post(
          Uri.parse(
              'https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=AIzaSyANliz-Nwmnann-w3l1YfsSX-2YWlnCtSY'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'dynamicLinkInfo': {
              'domainUriPrefix': 'https://docmanager.page.link',
              'link': downloadURL,
              'navigationInfo': {
                'enableForcedRedirect': true,
              }
            },
          }));

      Map<String, dynamic> list = jsonDecode(response.body);

      list.forEach(
          (key, value) => print('SHORT LINK -----\nKEY: $key\nVALUE: $value'));

      _fileList += '${element.name}:\n${list['shortLink']}\n\n';
    }

    final Uri params = Uri(scheme: 'mailto', path: _emails, queryParameters: {
      'subject': selectedReport.title,
      'BODY': '${textControllerContents.text}\n\n$_fileList',
    });

    String url = params.toString().replaceAll("+", "%20");
    if (await canLaunch(url)) {
      await launch(url);
      print('Launch $url');
    } else {
      print('Could not launch $url');
    }
  }

  getCompanyIcon(String name) {
    Widget icon;

    switch (name) {
      case '기아':
        icon = Icon(CompanyIcons.kia, color: Colors.redAccent, size: 60.0);
        break;
      case '현대':
        icon = Icon(CompanyIcons.hyundai, color: Colors.blue, size: 60.0);
        break;
      default:
        icon = Icon(Icons.keyboard_control, color: Colors.white, size: 60.0);
        break;
    }
    return icon;
  }

  Container reportTitle() => Container(
        padding: EdgeInsets.only(top: 30.0),
        height: (MediaQuery.of(context).size.width < 600) ? 100.0 : 150.0,
        decoration: BoxDecoration(
          color: Color(0xF2404B60),
          boxShadow: [
            BoxShadow(
              color: Color(0xF2404B60).withOpacity(0.5),
              blurRadius: 7,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            leading: Container(
              padding: EdgeInsets.only(right: 18.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right:
                          new BorderSide(width: 1.0, color: Colors.white24))),
              child: getCompanyIcon(selectedReport.companyName),
            ),
            title: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                selectedReport.factoryName,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 34.0),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Text(selectedReport.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(selectedReport.projectNum,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w300)),
                  ),
                ],
              ),
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: StreamBuilder(
                stream: firestore
                    .collection('user')
                    .doc(getUser().uid)
                    .collection('favorites')
                    .snapshots(),
                builder: (context, snapshot) {
                  bool flag = false;

                  if (!snapshot.hasData)
                    return IconButton(
                      onPressed: () async {
                        await firestore
                            .collection('user')
                            .doc(getUser().uid)
                            .collection('favorites')
                            .doc(selectedReport.projectNum)
                            .set({
                          'projectNum': selectedReport.projectNum,
                          'date': DateTime.now(),
                        });
                        createSnackBar('북마크에 추가되었습니다');
                      },
                      icon: Icon(Icons.bookmark_border),
                      iconSize: (MediaQuery.of(context).size.width < 600)
                          ? 24.0
                          : 46.0,
                      color: Colors.white,
                    );

                  snapshot.data.docs.forEach((element) {
                    if (element['projectNum'] == selectedReport.projectNum)
                      flag = true;
                  });

                  if (flag)
                    return IconButton(
                      onPressed: () async {
                        await firestore
                            .collection('user')
                            .doc(getUser().uid)
                            .collection('favorites')
                            .doc(selectedReport.projectNum)
                            .delete();
                        createSnackBar('북마크에서 제거되었습니다');
                      },
                      icon: Icon(Icons.bookmark),
                      iconSize: (MediaQuery.of(context).size.width < 600)
                          ? 24.0
                          : 46.0,
                      color: Colors.white,
                    );
                  else
                    return IconButton(
                      onPressed: () async {
                        await firestore
                            .collection('user')
                            .doc(getUser().uid)
                            .collection('favorites')
                            .doc(selectedReport.projectNum)
                            .set({
                          'projectNum': selectedReport.projectNum,
                          'date': DateTime.now(),
                        });
                        createSnackBar('북마크에 추가되었습니다');
                      },
                      icon: Icon(Icons.bookmark_border),
                      iconSize: (MediaQuery.of(context).size.width < 600)
                          ? 24.0
                          : 46.0,
                      color: Colors.white,
                    );
                },
              ),
            ),
          ),
        ),
      );

  ListTile makeListTile(Reference file) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        title: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Text(
            file.name,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Text(
            file.bucket,
            style: TextStyle(
                color: Colors.black,
                fontSize: 12.0,
                fontWeight: FontWeight.w300),
          ),
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () async {
                    String downloadURL =
                        await storage.ref(file.fullPath).getDownloadURL();
                    FlutterClipboard.copy(downloadURL).then(
                        (value) => createSnackBar('다운로드 링크가 클립보드에 복사되었습니다.'));
                  },
                  icon: Icon(Icons.share),
                  iconSize: 30.0),
              SizedBox(width: 10.0),
              IconButton(
                  onPressed: () async {
                    String downloadURL =
                        await storage.ref(file.fullPath).getDownloadURL();
                    if (await canLaunch(downloadURL)) {
                      await launch(downloadURL);
                    } else {
                      throw 'Could not launch $downloadURL';
                    }
                  },
                  icon: Icon(Icons.file_download),
                  iconSize: 30.0),
            ],
          ),
        ),
      );

  Card makeCard(Reference file) => Card(
        elevation: 0.0,
        margin: new EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF404B60)),
          ),
          child: makeListTile(file),
        ),
      );

  createSnackBar(String message) {
    final snackBar = new SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: true,
            leading: IconButton(
              icon: Icon(Icons.keyboard_arrow_left),
              onPressed: () {
                isBookmark ? onTabNavigate(2) : onTabNavigate(1);
              },
            ),
            title: Text('프로젝트 자세히 보기'),
            expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              background: reportTitle(),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: getUserInfo(selectedReport.manager),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Container();

                      String name =
                          snapshot.data.length != 0 ? snapshot.data[0] : '-';

                      return ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.contact_mail, color: Colors.white),
                        label: Text('$name',
                            style: TextStyle(color: Colors.white)),
                      );
                    },
                  ),
                  StreamBuilder(
                    stream: firestore
                        .collection('board')
                        .doc(selectedReport.projectNum)
                        .collection('contents')
                        .orderBy('date', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      List<Contents> _details = [];

                      if (!snapshot.hasData)
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Center(child: CircularProgressIndicator()));

                      for (var element in snapshot.data.docs) {
                        _details.add(Contents(
                            importance: element['importance'],
                            category: element['category'],
                            contents: element['contents'],
                            date: element['date'],
                            email: element['email'],
                            userName: element['userName']));
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.only(top: 10.0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _details.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 2.0,
                            color: Colors.white,
                            margin: const EdgeInsets.all(10.0),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            padding:
                                                EdgeInsets.only(right: 12.0),
                                            decoration: new BoxDecoration(
                                                border: new Border(
                                                    right: new BorderSide(
                                                        width: 1.0,
                                                        color:
                                                            Colors.white24))),
                                            child: (_details[index].importance)
                                                ? IconButton(
                                                    icon: Icon(Icons
                                                        .local_fire_department),
                                                    iconSize: 24.0,
                                                    color: Colors.red,
                                                    tooltip: '높은 중요도',
                                                    onPressed: () {},
                                                  )
                                                : IconButton(
                                                    icon:
                                                        Icon(Icons.trip_origin),
                                                    iconSize: 24.0,
                                                    color: Colors.green,
                                                    tooltip: '낮은 중요도',
                                                    onPressed: () {},
                                                  ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(top: 2.0),
                                            width: 240.0,
                                            child: Text(
                                                '${_details[index].category}',
                                                style: TextStyle(
                                                    fontSize: 24.0,
                                                    fontWeight:
                                                        FontWeight.w900)),
                                          ),
                                        ],
                                      ),
                                      Tooltip(
                                        message: '새 프로젝트 추가',
                                        child: Container(
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              await showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder:
                                                      (BuildContext context) {
                                                    return editAttachmentDialog(
                                                        context,
                                                        _details[index]);
                                                  });
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.greenAccent[400]),
                                              shape: MaterialStateProperty.all(
                                                  CircleBorder()),
                                            ),
                                            child: Icon(
                                              Icons.upload_file,
                                              color: Colors.white,
                                              size: 18.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.0),
                                  Divider(thickness: 0.3, color: Colors.black),
                                  SizedBox(height: 2.0),
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                          width: 150,
                                          child: Text('작성 시간',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      Text(
                                          DateFormat('yyyy.MM.dd kk:mm').format(
                                              _details[index].date.toDate()),
                                          style: TextStyle(fontSize: 16.0)),
                                    ],
                                  ),
                                  SizedBox(height: 2.0),
                                  Divider(thickness: 0.3, color: Colors.black),
                                  SizedBox(height: 2.0),
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                          width: 150,
                                          child: Text('작성자',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      AutoSizeText.rich(
                                        TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  '${_details[index].userName}',
                                            ),
                                            TextSpan(
                                              text:
                                                  '  ${_details[index].email}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                          style: TextStyle(
                                              fontFamily: 'SCDream',
                                              fontSize: 16.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.0),
                                  Divider(thickness: 0.3, color: Colors.black),
                                  SizedBox(height: 2.0),
                                  Text('내용',
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10.0),
                                  Text(_details[index].contents,
                                      style: TextStyle(fontSize: 16.0)),
                                  SizedBox(height: 2.0),
                                  Divider(thickness: 0.3, color: Colors.black),
                                  SizedBox(height: 2.0),
                                  FutureBuilder(
                                    future: storage
                                        .ref(
                                            '${selectedReport.companyName}/${selectedReport.factoryName}/${selectedReport.projectNum}/${_details[index].category}/${DateFormat().format(_details[index].date.toDate())}')
                                        .listAll(),
                                    builder: (context, snapshot) {
                                      List<Reference> _fileList = [];

                                      if (!snapshot.hasData)
                                        return Container(
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()));

                                      for (var element in snapshot.data.items) {
                                        _fileList.add(element);
                                      }

                                      return Container(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: _fileList.length,
                                          itemBuilder: (BuildContext context,
                                              int fileIndex) {
                                            return makeCard(
                                                _fileList[fileIndex]);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 100.0),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return addContentsDialog(context);
              });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
        tooltip: '새 내용 추가',
      ),
    );
  }
}

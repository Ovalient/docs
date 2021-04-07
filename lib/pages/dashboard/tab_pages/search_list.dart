import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:docs/models/model.dart';
import 'package:docs/pages/dashboard/list_detail_page.dart';
import 'package:docs/widgets/company_icons.dart';
import 'package:docs/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:docs/pages/dashboard_page.dart';

class SearchList extends StatefulWidget {
  SearchList({Key key}) : super(key: key);

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList>
    with AutomaticKeepAliveClientMixin {
  final firestore = FirebaseFirestore.instance;

  String _filter;
  bool _isFiltering = false;

  TextEditingController _textController;
  FocusNode _textFocusNode;

  bool _isSearching = false;
  bool _dateSearchOption = false;

  DateTime startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime endDate = DateTime.now();

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

  makeListTile(Report report) {
    return Card(
      child: InkWell(
        onTap: () {
          setState(() => previousPage = 1);
          if (MediaQuery.of(context).size.width > 600)
            onTabNavigate(3);
          else
            Navigator.pushNamed(context, ListDetailPage.id);
          selectedReport = report;
        },
        child: ListTile(
          title:
              Text(report.title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(report.projectNum),
          leading: getCompanyIcon(report.companyName),
          trailing: StreamBuilder(
            stream: firestore
                .collection('board')
                .doc(report.projectNum)
                .collection('contents')
                .orderBy('date', descending: true)
                .limit(1)
                .snapshots(),
            builder: (context, snapshot) {
              String listCategory = '';

              if (!snapshot.hasData) return SizedBox();

              snapshot.data.docs
                  .forEach((element) => listCategory = element['category']);

              if (listCategory == '종결-영업') {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4.0)),
                  padding: EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                  child: Text(
                    listCategory,
                    style: TextStyle(color: Colors.white, fontSize: 14.0),
                  ),
                );
              } else if (listCategory == '지급청구-실무') {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.red[900],
                      borderRadius: BorderRadius.circular(4.0)),
                  padding: EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                  child: Text(
                    listCategory,
                    style: TextStyle(color: Colors.white, fontSize: 14.0),
                  ),
                );
              } else if (listCategory == '거래명세-영업') {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(4.0)),
                  padding: EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                  child: Text(
                    listCategory,
                    style: TextStyle(color: Colors.white, fontSize: 14.0),
                  ),
                );
              } else if (listCategory == '') {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.red[300],
                      borderRadius: BorderRadius.circular(4.0)),
                  padding: EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                  child: Text(
                    '미작성',
                    style: TextStyle(color: Colors.white, fontSize: 14.0),
                  ),
                );
              } else {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(4.0)),
                  padding: EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                  child: Text(
                    listCategory,
                    style: TextStyle(color: Colors.white, fontSize: 14.0),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  getSearchQuery() async {
    switch (_filter) {
      case 'companyName':
        return FirebaseFirestore.instance
            .collection('board')
            .orderBy('companyName')
            .startAt([_textController.text]).endAt(
                [_textController.text + '\uf8ff']).get();
        break;
      case 'factoryName':
        return FirebaseFirestore.instance
            .collection('board')
            .orderBy('factoryName')
            .startAt([_textController.text]).endAt(
                [_textController.text + '\uf8ff']).get();
        break;
      case 'projectNum':
        return FirebaseFirestore.instance
            .collection('board')
            .orderBy('projectNum')
            .startAt([_textController.text]).endAt(
                [_textController.text + '\uf8ff']).get();
        break;
      case 'title':
        return FirebaseFirestore.instance
            .collection('board')
            .orderBy('title')
            .startAt([_textController.text]).endAt(
                [_textController.text + '\uf8ff']).get();
        break;
      case 'manager':
        String uid;
        if (_textController.text == '미정') {
          return FirebaseFirestore.instance
              .collection('board')
              .where('manager', isEqualTo: '미정');
        } else {
          await FirebaseFirestore.instance
              .collection('user')
              .where('userName', isEqualTo: _textController.text)
              .get()
              .then(
                  (value) => value.docs.forEach((element) => uid = element.id));

          print(uid);

          return FirebaseFirestore.instance
              .collection('board')
              .orderBy('manager')
              .startAt([uid]).endAt([uid + '\uf8ff']).get();
        }
        break;
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textController.text = null;
    _textFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomRadioButton(
            elevation: 0.0,
            padding: 4.0,
            width: 120.0,
            enableShape: true,
            selectedColor: Theme.of(context).accentColor,
            unSelectedColor: Theme.of(context).canvasColor,
            buttonTextStyle: ButtonTextStyle(
                selectedColor: Colors.white,
                unSelectedColor: Colors.black,
                textStyle: TextStyle(fontSize: 16)),
            buttonLables: ["회사", "공장", "프로젝트 번호", "프로젝트 명", "PM"],
            buttonValues: [
              "companyName",
              "factoryName",
              "projectNum",
              "title",
              "manager",
            ],
            radioButtonValue: (value) {
              print(value);
              setState(() {
                _filter = value;
                _isFiltering = true;
              });
              Future.delayed(Duration(milliseconds: 100),
                  () => _textFocusNode.requestFocus());
            },
          ),
          Row(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Checkbox(
                    activeColor: Colors.red,
                    value: _dateSearchOption,
                    onChanged: (value) {
                      setState(() {
                        _dateSearchOption = value;
                      });
                    },
                  ),
                  Text('날짜 검색'),
                ],
              ),
              SizedBox(width: 10.0),
              SizedBox(
                width: 150.0,
                child: MaterialButton(
                  onPressed: (_dateSearchOption)
                      ? () {
                          DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            minTime: DateTime(2018, 3, 1),
                            maxTime: DateTime.now(),
                            currentTime:
                                DateTime.now().subtract(Duration(days: 30)),
                            locale: LocaleType.ko,
                            onConfirm: (date) {
                              if (date.isAfter(endDate)) {
                                setState(() {
                                  startDate = DateTime.now()
                                      .subtract(Duration(days: 30));
                                  endDate = DateTime.now();
                                });
                                dateDialog(context);
                              } else
                                setState(() => startDate = date);
                            },
                          );
                        }
                      : null,
                  shape: Border(bottom: BorderSide()),
                  child: Text(DateFormat('yyyy.MM.dd').format(startDate)),
                ),
              ),
              SizedBox(width: 10.0),
              SizedBox(
                width: 150.0,
                child: MaterialButton(
                  onPressed: (_dateSearchOption)
                      ? () {
                          DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            minTime: DateTime(2018, 3, 1),
                            maxTime: DateTime.now(),
                            currentTime: DateTime.now(),
                            locale: LocaleType.ko,
                            onConfirm: (date) {
                              if (date.isBefore(startDate)) {
                                setState(() {
                                  startDate = DateTime.now()
                                      .subtract(Duration(days: 30));
                                  endDate = DateTime.now();
                                });
                                dateDialog(context);
                              } else
                                setState(() => endDate = date);
                            },
                          );
                        }
                      : null,
                  shape: Border(bottom: BorderSide()),
                  child: Text(DateFormat('yyyy.MM.dd').format(endDate)),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          TextField(
            enabled: (_isFiltering) ? true : false,
            textInputAction: TextInputAction.next,
            autofocus: true,
            focusNode: _textFocusNode,
            style: TextStyle(color: Colors.black),
            controller: _textController,
            onSubmitted: (value) {
              setState(() {
                _isSearching = true;
              });
              _textFocusNode.requestFocus();
            },
            decoration: InputDecoration(
              border: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.blueGrey[800],
                  width: 3,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = true;
                  });
                },
                icon: Icon(Icons.search),
              ),
              filled: true,
              hintStyle: new TextStyle(
                color: Colors.blueGrey[300],
              ),
              hintText: '검색',
              fillColor: Colors.white,
            ),
          ),
          SizedBox(height: 20.0),
          (_isFiltering && _isSearching)
              ? FutureBuilder(
                  future: getSearchQuery(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Report> documents = [];

                      snapshot.data.docs.forEach((element) {
                        documents.add(Report(
                          companyName: element.data()['companyName'],
                          factoryName: element.data()['factoryName'],
                          projectNum: element.data()['projectNum'],
                          manager: element.data()['manager'],
                          title: element.data()['title'],
                          views: element.data()['views'],
                        ));
                      });

                      documents.reversed;

                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          return makeListTile(documents[index]);
                        },
                      );
                    } else {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Center(child: CircularProgressIndicator()));
                    }
                  },
                )
              : Container(),
        ],
      ),
    );
  }
}

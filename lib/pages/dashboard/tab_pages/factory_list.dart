import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docs/models/model.dart';
import 'package:docs/pages/dashboard/list_detail_page.dart';
import 'package:docs/pages/dashboard_page.dart';
import 'package:docs/widgets/company_icons.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class FactoryList extends StatefulWidget {
  FactoryList({Key key}) : super(key: key);

  @override
  _FactoryListState createState() => _FactoryListState();
}

class _FactoryListState extends State<FactoryList>
    with AutomaticKeepAliveClientMixin {
  final firestore = FirebaseFirestore.instance;

  String _selectedCompany;
  String _selectedFactory;
  bool _isCompanySelected = false;
  bool _isFactorySelected = false;

  getCompanyIcon(String name, double size) {
    Widget icon;

    switch (name) {
      case '기아':
        icon = Icon(CompanyIcons.kia, color: Colors.redAccent, size: size);
        break;
      case '현대':
        icon = Icon(CompanyIcons.hyundai, color: Colors.blue, size: size);
        break;
      default:
        icon = Icon(Icons.keyboard_control, color: Colors.white, size: size);
        break;
    }
    return icon;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
      child: (_isCompanySelected)
          // Factory select page
          ? (_isFactorySelected)
              ? Column(
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        setState(() => _isFactorySelected = false);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.keyboard_arrow_left,
                            size: 18.0,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            '공장 선택',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    PaginateFirestore(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemsPerPage: 12,
                      query: firestore
                          .collection('board')
                          .where('companyName', isEqualTo: _selectedCompany)
                          .where('factoryName', isEqualTo: _selectedFactory)
                          .orderBy('date', descending: true),
                      isLive: true,
                      itemBuilderType: PaginateBuilderType.listView,
                      itemBuilder: (index, context, documentSnapshot) => Card(
                        child: InkWell(
                          onTap: () {
                            setState(() => isBookmark = false);
                            if (MediaQuery.of(context).size.width > 600)
                              onTabNavigate(3);
                            else
                              Navigator.pushNamed(context, ListDetailPage.id);
                            selectedReport = Report(
                              companyName:
                                  documentSnapshot.data()['companyName'],
                              date: documentSnapshot.data()['date'],
                              factoryName:
                                  documentSnapshot.data()['factoryName'],
                              manager: documentSnapshot.data()['manager'],
                              projectNum: documentSnapshot.data()['projectNum'],
                              title: documentSnapshot.data()['title'],
                              views: documentSnapshot.data()['views'],
                            );
                          },
                          child: ListTile(
                            title: Text(documentSnapshot.data()['title'],
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(documentSnapshot.id),
                            leading: getCompanyIcon(
                                documentSnapshot.data()['companyName'], 30.0),
                            trailing: StreamBuilder(
                              stream: firestore
                                  .collection('board')
                                  .doc(documentSnapshot.data()['projectNum'])
                                  .collection('contents')
                                  .orderBy('date', descending: true)
                                  .limit(1)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                String listCategory = '';

                                if (!snapshot.hasData) return SizedBox();

                                snapshot.data.docs.forEach((element) =>
                                    listCategory = element['category']);
                                if (listCategory == '종결-영업') {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                    padding: EdgeInsets.only(
                                        left: 10.0,
                                        right: 10.0,
                                        top: 5.0,
                                        bottom: 5.0),
                                    child: Text(
                                      listCategory,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14.0),
                                    ),
                                  );
                                } else if (listCategory == '지급청구-실무') {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                    padding: EdgeInsets.only(
                                        left: 10.0,
                                        right: 10.0,
                                        top: 5.0,
                                        bottom: 5.0),
                                    child: Text(
                                      listCategory,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14.0),
                                    ),
                                  );
                                } else if (listCategory == '') {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                    padding: EdgeInsets.only(
                                        left: 10.0,
                                        right: 10.0,
                                        top: 5.0,
                                        bottom: 5.0),
                                    child: Text(
                                      '미작성',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14.0),
                                    ),
                                  );
                                } else {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: Colors.orange[700],
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                    padding: EdgeInsets.only(
                                        left: 10.0,
                                        right: 10.0,
                                        top: 5.0,
                                        bottom: 5.0),
                                    child: Text(
                                      listCategory,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14.0),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        setState(() => _isCompanySelected = false);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.keyboard_arrow_left,
                            size: 18.0,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            '사이트 선택',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    StreamBuilder(
                        stream: firestore
                            .collection('factory')
                            .doc(_selectedCompany)
                            .snapshots(),
                        builder: (context, snapshot) {
                          List<String> _names = [];

                          if (!snapshot.hasData)
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child:
                                    Center(child: CircularProgressIndicator()));

                          snapshot.data['name'].forEach((element) {
                            _names.add(element);
                          });

                          _names.sort((a, b) {
                            return a.compareTo(b);
                          });

                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _names.length,
                            itemBuilder: (context, index) {
                              return MaterialButton(
                                color: Color(0xFFF3F3F3),
                                hoverColor: Color(0xFFE5E5E5),
                                onPressed: () {
                                  setState(() {
                                    _selectedFactory = _names[index];
                                    _isFactorySelected = true;
                                  });
                                },
                                child: ListTile(
                                    title: Text(_names[index]),
                                    trailing: Icon(Icons.keyboard_arrow_right)),
                              );
                            },
                            separatorBuilder: (context, index) {
                              if (index == _names.length - 1)
                                return SizedBox();
                              else
                                return SizedBox(height: 10.0);
                            },
                          );
                        }),
                  ],
                )
          // Company select page
          : StreamBuilder(
              stream: firestore.collection('factory').snapshots(),
              builder: (context, snapshot) {
                List<String> _companyId = [];

                if (!snapshot.hasData)
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(child: CircularProgressIndicator()));

                snapshot.data.docs
                    .forEach((element) => _companyId.add(element.id));

                _companyId.sort((a, b) {
                  return b.compareTo(a);
                });

                return Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height:
                      (MediaQuery.of(context).size.width < 600) ? 150.0 : 300.0,
                  child: Center(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(20.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: _companyId.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          hoverColor: Color(0xF24D535E),
                          onTap: () {
                            setState(() {
                              _selectedCompany = _companyId[index];
                              _isCompanySelected = true;
                            });
                          },
                          child: Card(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: (MediaQuery.of(context).size.width < 600)
                                    ? getCompanyIcon(_companyId[index], 50.0)
                                    : getCompanyIcon(_companyId[index], 200.0),
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xF2404B60),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xF2404B60).withOpacity(0.5),
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 2), // changes position of shadow
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

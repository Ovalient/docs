import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docs/models/model.dart';
import 'package:docs/pages/dashboard/list_detail_page.dart';
import 'package:docs/pages/dashboard_page.dart';
import 'package:docs/utils/data_source.dart';
import 'package:docs/widgets/company_icons.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentList extends StatefulWidget {
  RecentList({Key key}) : super(key: key);

  @override
  _RecentListState createState() => _RecentListState();
}

class _RecentListState extends State<RecentList>
    with AutomaticKeepAliveClientMixin {
  final firestore = FirebaseFirestore.instance;

  bool _viewType = false;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  _loadViewType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _viewType = prefs.getBool('view_type') ?? false;
    });
  }

  _setViewType(bool flag) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _viewType = flag;
      prefs.setBool('view_type', flag);
    });
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

  Widget listView() {
    return PaginateFirestore(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemsPerPage: 12,
      query: firestore.collection('board').orderBy('date', descending: true),
      isLive: true,
      itemBuilderType: PaginateBuilderType.listView,
      itemBuilder: (index, context, documentSnapshot) => Card(
        child: InkWell(
          onTap: () {
            setState(() => previousPage = 1);
            if (MediaQuery.of(context).size.width > 600)
              onTabNavigate(3);
            else
              Navigator.pushNamed(context, ListDetailPage.id);
            selectedReport = Report(
              companyName: documentSnapshot.data()['companyName'],
              date: documentSnapshot.data()['date'],
              factoryName: documentSnapshot.data()['factoryName'],
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
            leading: getCompanyIcon(documentSnapshot.data()['companyName']),
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
      ),
    );
  }

  Widget tableView() {
    return StreamBuilder(
      stream: firestore
          .collection('board')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(child: CircularProgressIndicator()));

        List<Report> list = [];
        snapshot.data.docs.forEach((element) {
          list.add(Report(
            companyName: element['companyName'],
            factoryName: element['factoryName'],
            projectNum: element['projectNum'],
            manager: element['manager'],
            title: element['title'],
            date: element['date'],
            views: element['views'],
          ));
        });

        var documents = ReportDataSource(list, context);

        return PaginatedDataTable(
          showCheckboxColumn: false,
          columns: [
            DataColumn(
              label: Text(
                '제조사',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                '사이트',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                '프로젝트 번호',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                '프로젝트 명',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                '최초 작성 일자',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          source: documents,
          availableRowsPerPage: [10, 20, 30],
          onRowsPerPageChanged: (index) {
            setState(() {
              _rowsPerPage = index;
            });
          },
          rowsPerPage: _rowsPerPage,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadViewType();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    await _setViewType(false);
                  },
                  child: Container(
                    height: 56,
                    width: 56,
                    color: (!_viewType) ? Colors.grey : Colors.transparent,
                    child: Icon(Icons.list_alt_sharp,
                        color: (!_viewType) ? Colors.white : Colors.black),
                  ),
                ),
                SizedBox(width: 4),
                InkWell(
                  onTap: () async {
                    await _setViewType(true);
                  },
                  child: Container(
                    height: 56,
                    width: 56,
                    color: (_viewType) ? Colors.grey : Colors.transparent,
                    child: Icon(Icons.table_chart_sharp,
                        color: (_viewType) ? Colors.white : Colors.black),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          _viewType ? tableView() : listView(),
        ],
      ),
    );
  }
}

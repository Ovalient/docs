import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docs/models/model.dart';
import 'package:docs/pages/dashboard/list_detail_page.dart';
import 'package:docs/pages/dashboard_page.dart';
import 'package:docs/utils/firebase_provider.dart';
import 'package:docs/widgets/company_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecentDataSource extends DataTableSource {
  final List<Report> list;
  final BuildContext context;

  RecentDataSource(this.list, this.context);

  DataRow getRow(int index) {
    final report = list[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(getCompanyIcon(report.companyName)),
        DataCell(Text(report.factoryName)),
        DataCell(Text(report.projectNum)),
        DataCell(Text(report.title)),
        DataCell(report.manager == '미정'
            ? Text('미정')
            : FutureBuilder(
                future: firestore.collection('user').doc(report.manager).get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Text('...');
                  else
                    return Text(snapshot.data['userName']);
                },
              )),
        DataCell(
          FutureBuilder(
            future: firestore
                .collection('board')
                .doc(report.projectNum)
                .collection('contents')
                .orderBy('date', descending: true)
                .limit(1)
                .get(),
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
        DataCell(Text(DateFormat('yyyy.MM.dd').format(report.date.toDate()))),
      ],
      onSelectChanged: (value) {
        previousPage = 1;
        if (MediaQuery.of(context).size.width > 600)
          onTabNavigate(3);
        else
          Navigator.pushNamed(context, ListDetailPage.id);
        selectedReport = Report(
          companyName: report.companyName,
          date: report.date,
          factoryName: report.factoryName,
          manager: report.manager,
          projectNum: report.projectNum,
          title: report.title,
          views: report.views,
        );
      },
    );
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => list.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

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
}

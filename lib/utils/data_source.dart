import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docs/models/report.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final firestore = FirebaseFirestore.instance;

class ReportDataSource extends DataTableSource {
  final List<Report> list;

  ReportDataSource(this.list);

  DataRow getRow(int index) {
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(list[index].companyName)),
        DataCell(Text(list[index].factoryName)),
        DataCell(Text(list[index].projectNum)),
        DataCell(Text(list[index].title)),
        DataCell(
          StreamBuilder(
            stream: firestore
                .collection('board')
                .doc(list[index].projectNum)
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
                      color: Colors.redAccent,
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
                      color: Colors.redAccent,
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
                      color: Colors.orange[700],
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
      ],
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
}

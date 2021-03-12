import 'package:docs/models/report.dart';
import 'package:docs/utils/data_source.dart';
import 'package:flutter/material.dart';

class ProjectListPage extends StatefulWidget {
  static const String id = '/layoutPage/projectListPage';
  ProjectListPage({Key key}) : super(key: key);

  @override
  _ProjectListPageState createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('프로젝트 리스트'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
          child: StreamBuilder(
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
                  title: element['title'],
                  date: element['date'],
                  views: element['views'],
                ));
              });
              print(list.length);
              var documents = ReportDataSource(list);

              return PaginatedDataTable(
                columns: [
                  DataColumn(
                    label: Container(
                      width: 50,
                      child: Text(
                        '제조사',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      width: 100,
                      child: Text(
                        '사이트',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      width: 150,
                      child: Text(
                        '프로젝트 번호',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      width: 600,
                      child: Text(
                        '프로젝트 명',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      '최근 문서',
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
          ),
        ),
      ),
    );
  }
}

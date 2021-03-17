import 'package:docs/models/model.dart';
import 'package:docs/pages/dashboard_page.dart';
import 'package:docs/widgets/company_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportDataSource extends DataTableSource {
  final List<Report> list;

  ReportDataSource(this.list);

  DataRow getRow(int index) {
    final report = list[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(getCompanyIcon(report.companyName)),
        DataCell(Text(report.factoryName)),
        DataCell(Text(report.projectNum)),
        DataCell(Text(report.title)),
        DataCell(Text(DateFormat('yyyy.MM.dd').format(report.date.toDate()))),
      ],
      onSelectChanged: (value) {
        onTabNavigate(3);
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

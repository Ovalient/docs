import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  String companyName;
  Timestamp date;
  String factoryName;
  String manager;
  String projectNum;
  String title;
  int views;

  Report(
      {this.companyName,
      this.date,
      this.factoryName,
      this.manager,
      this.projectNum,
      this.title,
      this.views});
}

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

class Contents {
  bool importance;
  String category;
  String contents;
  Timestamp date;
  String email;
  String userName;

  Contents(
      {this.importance,
      this.category,
      this.contents,
      this.date,
      this.email,
      this.userName});
}

Report selectedReport;

String userEmail;
String userName;
String userRank;

int previousPage;

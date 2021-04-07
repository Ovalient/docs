import 'package:docs/pages/auth_page.dart';
import 'package:docs/pages/dashboard/admin_page.dart';
import 'package:docs/pages/dashboard/admin_pages/user_manage_pages/add_user_page.dart';
import 'package:docs/pages/dashboard/admin_pages/user_manage_pages/delete_user_page.dart';
import 'package:docs/pages/dashboard/admin_pages/user_manage_pages/edit_user_page.dart';
import 'package:docs/pages/dashboard/bookmark_page.dart';
import 'package:docs/pages/dashboard/main_page.dart';
import 'package:docs/pages/dashboard/project_list_page.dart';
import 'package:docs/pages/dashboard/list_detail_page.dart';
import 'package:docs/pages/dashboard_page.dart';
import 'package:docs/pages/login_page.dart';
import 'package:docs/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '프로젝트 정보 공유 게시판',
      theme: mainTheme,
      initialRoute: AuthPage.id,
      routes: {
        AuthPage.id: (context) => AuthPage(),
        LoginPage.id: (context) => LoginPage(),
        DashboardPage.id: (context) => DashboardPage(),
        MainPage.id: (context) => MainPage(),
        ProjectListPage.id: (context) => ProjectListPage(),
        BookmarkPage.id: (context) => BookmarkPage(),
        ListDetailPage.id: (context) => ListDetailPage(),
        AdminPage.id: (context) => AdminPage(),
        AddUserPage.id: (context) => AddUserPage(),
        EditUserPage.id: (context) => EditUserPage(),
        DeleteUserPage.id: (context) => DeleteUserPage(),
      },
    );
  }
}

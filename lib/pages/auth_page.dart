import 'package:after_layout/after_layout.dart';
import 'package:docs/pages/layout_page.dart';
import 'package:docs/pages/login_page.dart';
import 'package:docs/utils/firebase_provider.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  static const String id = "/authPage";
  AuthPage({Key key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with AfterLayoutMixin<AuthPage> {
  _userLoggedIn() {
    if (getUser() != null && getUser().emailVerified) {
      Navigator.popAndPushNamed(context, LayoutPage.id);
    } else {
      Navigator.popAndPushNamed(context, LoginPage.id);
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => _userLoggedIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

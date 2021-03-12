import 'package:docs/pages/dashboard_page.dart';
import 'package:docs/utils/firebase_provider.dart';
import 'package:docs/widgets/dialogs.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static const String id = '/loginPage';
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;

  String loginStatus;
  Color loginStringColor = Colors.green;

  void signInRequest() async {
    if (_emailController.text != null && _passwordController.text != null) {
      await signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ).then((result) {
        if (result == null) {
          print(result);
          setState(() {
            loginStatus = 'You have successfully signed in';
            loginStringColor = Colors.green;
          });
          Navigator.popAndPushNamed(context, DashboardPage.id);
        } else if (result == '이메일 주소 인증이 필요합니다') {
          setState(() {
            loginStatus = result;
            loginStringColor = Colors.green;
          });
          emailVerificationDialog(context);
        } else {
          setState(() {
            loginStatus = result;
            loginStringColor = Colors.red;
          });
        }
      });
    } else {
      setState(() {
        loginStatus = 'Please enter email & password';
        loginStringColor = Colors.red;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailController.text = null;
    _passwordController.text = null;
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SingleChildScrollView(
        child: Container(
          width: 300.0,
          margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 50.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.asset('icons/logo.png'),
                SizedBox(height: 30.0),
                Text(
                  'Email 주소',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.subtitle2.color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    // letterSpacing: 3,
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  focusNode: _emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  controller: _emailController,
                  autofocus: false,
                  onSubmitted: (value) {
                    _emailFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.blueGrey[800],
                        width: 3,
                      ),
                    ),
                    filled: true,
                    hintStyle: new TextStyle(
                      color: Colors.blueGrey[300],
                    ),
                    hintText: "Email",
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  '비밀번호',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.subtitle2.color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    // letterSpacing: 3,
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  focusNode: _passwordFocusNode,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  controller: _passwordController,
                  obscureText: true,
                  autofocus: false,
                  onSubmitted: (value) {
                    signInRequest();
                    //textFocusNodePassword.unfocus();
                  },
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.blueGrey[800],
                        width: 3,
                      ),
                    ),
                    filled: true,
                    hintStyle: new TextStyle(
                      color: Colors.blueGrey[300],
                    ),
                    hintText: "Password",
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 15.0),
                loginStatus != null
                    ? Center(
                        child: Text(loginStatus,
                            style: TextStyle(
                                color: loginStringColor, fontSize: 14.0)))
                    : Container(),
                SizedBox(height: 15.0),
                MaterialButton(
                  elevation: 0,
                  minWidth: double.maxFinite,
                  height: 50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  onPressed: () async {
                    setState(() {
                      _emailFocusNode.unfocus();
                      _passwordFocusNode.unfocus();
                    });
                    signInRequest();
                  },
                  color: Colors.blueGrey[800],
                  hoverColor: Colors.blueGrey[900],
                  highlightColor: Colors.black,
                  child: Text('Login',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:docs/pages/dashboard_page.dart';
import 'package:docs/utils/firebase_provider.dart';
import 'package:docs/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

class LoginPage extends StatefulWidget {
  static const String id = '/loginPage';
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _resetController;
  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;
  FocusNode _resetFocusNode;

  String loginStatus;
  Color loginStringColor = Colors.green;

  bool _isEmailExists = true;

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

  resetPasswordDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AssetGiffyDialog(
        image: Image.asset('assets/images/email_verification.gif',
            fit: BoxFit.cover),
        cornerRadius: 0.0,
        buttonRadius: 0.0,
        onlyOkButton: true,
        title: Text(
          '비밀번호 초기화',
          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
        ),
        description: Text(
          '비밀번호 초기화 메일을 보냈습니다.\n이메일 확인 후, 다시 로그인 하세요.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
        entryAnimation: EntryAnimation.DEFAULT,
        buttonOkColor: Theme.of(context).accentColor,
        onOkButtonPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  errorDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AssetGiffyDialog(
        image: Image.asset('assets/images/error.gif', fit: BoxFit.cover),
        cornerRadius: 0.0,
        buttonRadius: 0.0,
        onlyOkButton: true,
        title: Text(
          '오류',
          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
        ),
        description: Text(
          '최근 비밀번호 초기화 요청이 너무 많았습니다.\n잠시 후 다시 시도해주세요.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
        entryAnimation: EntryAnimation.DEFAULT,
        buttonOkColor: Theme.of(context).accentColor,
        onOkButtonPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _resetController = TextEditingController();
    _emailController.text = null;
    _passwordController.text = null;
    _resetController.text = null;
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _resetFocusNode = FocusNode();
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
                SizedBox(height: 10.0),
                Container(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                        onTap: () async {
                          await showDialog(
                              context: context,
                              builder: (BuildContext subContext) {
                                return AlertDialog(
                                  title: Text('이메일을 입력하세요'),
                                  content: StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            focusNode: _resetFocusNode,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.done,
                                            controller: _resetController,
                                            autofocus: true,
                                            onSubmitted: (value) async {
                                              if (await sendPasswordResetEmail(
                                                  email:
                                                      _resetController.text)) {
                                                Navigator.pop(context);
                                                resetPasswordDialog();
                                              } else {
                                                errorDialog();
                                              }
                                            },
                                            style:
                                                TextStyle(color: Colors.black),
                                            decoration: InputDecoration(
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                                          SizedBox(height: 15.0),
                                          Container(
                                              alignment: Alignment.centerRight,
                                              child: MaterialButton(
                                                  onPressed: () async {
                                                    if (await sendPasswordResetEmail(
                                                        email: _resetController
                                                            .text)) {
                                                      Navigator.pop(context);
                                                      resetPasswordDialog();
                                                    } else {
                                                      errorDialog();
                                                    }
                                                  },
                                                  child: Text('확인')))
                                        ],
                                      );
                                    },
                                  ),
                                );
                              });
                        },
                        child: Text('비밀번호를 잊으셨나요?',
                            style: TextStyle(color: Colors.blue)))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

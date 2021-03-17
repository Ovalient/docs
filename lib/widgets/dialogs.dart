import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

emailVerificationDialog(BuildContext context) {
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
        '이메일 인증',
        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
      ),
      description: Text(
        '인증 메일을 보냈습니다.\n이메일 확인 후, 다시 로그인 하세요.',
        textAlign: TextAlign.center,
        style: TextStyle(),
      ),
      entryAnimation: EntryAnimation.DEFAULT,
      buttonOkColor: Theme.of(context).accentColor,
      onOkButtonPressed: () {
        Navigator.of(context).pop();
      },
    ),
  );
}

dateDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: <Widget>[
            Icon(Icons.report_problem),
            SizedBox(width: 10.0),
            Text('알림', style: TextStyle(fontWeight: FontWeight.w900)),
          ],
        ),
        content: Text('날짜가 정확하지 않습니다'),
        actions: [
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK')),
        ],
      );
    },
  );
}

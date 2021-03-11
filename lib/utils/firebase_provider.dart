import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// class FirebaseProvider {
//   final FirebaseAuth _auth; // Firebase 인증 플러그인의 인스턴스
//   FirebaseProvider(this._auth);

//   Stream<User> get authState => _auth.idTokenChanges();

//   getUser() {
//     User user = _auth.currentUser;
//     return user;
//   }

//   // 이메일/비밀번호로 Firebase에 회원가입
//   Future<bool> signUp({String email, String password}) async {
//     bool flag = false;

//     try {
//       final userCredential = await _auth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       if (userCredential.user != null) {
//         return flag = true;
//       }
//     } catch (e) {
//       print(e);
//     }
//     return flag;
//   }

//   // 이메일/비밀번호로 Firebase에 로그인
//   Future<bool> signIn({String email, String password}) async {
//     bool flag = false;

//     try {
//       final userCredential = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       if (userCredential.user != null) {
//         return flag = true;
//       }
//     } catch (e) {
//       print(e);
//     }
//     return flag;
//   }

//   // Firebase로부터 로그아웃
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }

//   // 사용자에게 비밀번호 재설정 메일을 영어로 전송 시도
//   sendPasswordResetEmailByEnglish() async {
//     await _auth.setLanguageCode("en");
//     sendPasswordResetEmail();
//   }

//   // 사용자에게 비밀번호 재설정 메일을 한글로 전송 시도
//   sendPasswordResetEmailByKorean() async {
//     await _auth.setLanguageCode("ko");
//     sendPasswordResetEmail();
//   }

//   // 사용자에게 비밀번호 재설정 메일을 전송
//   sendPasswordResetEmail() async {
//     User user = getUser();
//     _auth.sendPasswordResetEmail(email: user.email);
//   }

//   // Firebase로부터 회원 탈퇴
//   withdrawalAccount() async {
//     User user = getUser();
//     await user.delete();
//   }
// }

final FirebaseAuth _auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;

User getUser() {
  User user = _auth.currentUser;
  return user;
}

// 이메일/비밀번호로 Firebase에 회원가입
Future<String> signUp({String username, String email, String password}) async {
  String errorMessage;

  try {
    final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (userCredential.user != null) {
      userCredential.user.sendEmailVerification();
      try {
        await firestore.collection('user').doc(userCredential.user.uid).set({
          'username': username,
          'email': email,
        });
      } on FirebaseException catch (e) {
        // e.g, e.code == 'canceled'
      }
      return errorMessage = null;
    }
  } catch (e) {
    switch (e.code) {
      case "email-already-in-use":
        errorMessage = "동일한 이메일이 등록되어 있습니다";
        break;
      case "invalid-email":
        errorMessage = "이메일 주소가 유효하지 않습니다";
        break;
      case "operation-not-allowed":
        errorMessage = "이메일 주소와 비밀번호를 사용할 수 없습니다";
        break;
      case "weak-password":
        errorMessage = "비밀번호가 안전하지 않습니다";
        break;
      default:
        errorMessage = "이메일 주소와 비밀번호를 확인해주세요";
    }
  }
  return errorMessage;
}

// 이메일/비밀번호로 Firebase에 로그인
Future<String> signIn({String email, String password}) async {
  String errorMessage;

  try {
    final userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    if (userCredential.user != null && userCredential.user.emailVerified) {
      return errorMessage = null;
    } else {
      userCredential.user.sendEmailVerification();
      return "이메일 주소 인증이 필요합니다";
    }
  } catch (e) {
    switch (e.code) {
      case "invalid-email":
        errorMessage = "이메일 주소가 잘못되었습니다";
        break;
      case "wrong-password":
        errorMessage = "비밀번호가 잘못되었습니다";
        break;
      case "user-not-found":
        errorMessage = "등록되지 않은 이메일 주소입니다";
        break;
      case "user-disabled":
        errorMessage = "비활성화 된 이메일 주소입니다";
        break;
      default:
        errorMessage = "이메일 주소와 비밀번호를 확인해주세요";
    }
  }
  return errorMessage;
}

// Firebase로부터 로그아웃
Future<void> signOut() async {
  await _auth.signOut();
}

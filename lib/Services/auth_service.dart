import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hirecue_app/screens/Authentication/sign_in.dart';
import 'package:hirecue_app/screens/Home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Validate password strength
      List<String> validationMessages = _validatePassword(password);
      if (validationMessages.isNotEmpty) {
        Fluttertoast.showToast(
          msg: validationMessages.join('\n'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        return;
      }

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await sendEmailVerification(userCredential.user!);

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => Home()),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {
      print('Signup Error: ${e.toString()}');
    }
  }

  Future<void> sendEmailVerification(User user) async {
    try {
      await user.sendEmailVerification();
      Fluttertoast.showToast(
        msg: 'Verification email sent',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {
      print('Failed to send email verification: ${e.toString()}');
    }
  }

  List<String> _validatePassword(String password) {
    List<String> messages = [];
    if (password.length < 8) {
      messages.add('✘ Password must be at least 8 characters long.');
    }
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(password)) {
      messages.add('✘ Include at least one uppercase letter.');
    }
    if (!RegExp(r'(?=.*[a-z])').hasMatch(password)) {
      messages.add('✘ Include at least one lowercase letter.');
    }
    if (!RegExp(r'(?=.*\d)').hasMatch(password)) {
      messages.add('✘ Include at least one digit.');
    }
    if (!RegExp(r'(?=.*[!@#\$&*~])').hasMatch(password)) {
      messages.add('✘ Include at least one special character.');
    }
    return messages;
  }

  Future<bool> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idToken = await userCredential.user!.getIdToken();
      if (idToken != null) {
        await prefs.setString('idToken', idToken);
      } else {
        print('Id token is null');
      }

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => Home()),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      return false;
    } catch (e) {
      print('Signin Error: ${e.toString()}');
      return false;
    }
  }

  Future<void> signout({
    required BuildContext context,
  }) async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('idToken');
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const SignIn()),
    );
  }

  void signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        Fluttertoast.showToast(
          msg: "Google sign-in canceled by user.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

     SharedPreferences prefs = await SharedPreferences.getInstance();
String? idToken = await userCredential.user!.getIdToken();
if (idToken != null) {
  await prefs.setString('idToken', idToken);
} else {
  // Handle case where idToken is null, if needed
  print('Id token is null');
}

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => Home()),
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Google sign-in failed: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> googleSignout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}

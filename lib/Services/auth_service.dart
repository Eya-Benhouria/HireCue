import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hirecue_app/screens/Authentication/sign_in.dart';
import 'package:hirecue_app/screens/Home/home.dart';

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
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const Home()),
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

  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const Home()),
      );
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
    } catch (e) {
      print('Signin Error: ${e.toString()}');
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signout({
    required BuildContext context,
  }) async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const SignIn()),
    );
  }

  void signInWithGoogle(BuildContext context) async {
    try {
      print('Attempting to sign in with Google...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Google sign-in canceled by user.');
        Fluttertoast.showToast(
          msg: "Google sign-in canceled by user.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        return; // The user canceled the sign-in
      }

      print('Google sign-in successful, retrieving authentication tokens...');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print('Creating AuthCredential from Google authentication tokens...');
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('Signing in with Google AuthCredential...');
      await _auth.signInWithCredential(credential);

      print('Navigation to Home after Google sign-in...');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const Home()),
      );
    } catch (e) {
      print('Google sign-in error: ${e.toString()}');
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

  Future<void> googleSignout() async {
    print('Signing out from Google...');
    await _auth.signOut();
    await _googleSignIn.signOut();
    print('Google sign-out successful.');
  }
}

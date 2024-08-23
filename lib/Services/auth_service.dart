import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hirecue_app/screens/Authentication/sign_in.dart';
import 'package:hirecue_app/screens/Home/home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final String apiUrl =
      'http://212.132.108.203/'; // Replace with your API base URL
  final String firebaseApiKey =
      'YOUR_FIREBASE_API_KEY'; // Replace with your Firebase API Key

  Future<bool> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Password validation
      List<String> validationMessages = _validatePassword(password);
      if (validationMessages.isNotEmpty) {
        Fluttertoast.showToast(
          msg: validationMessages.join('\n'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        return false;
      }

      // Create user with Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      await sendEmailVerification(userCredential.user!);

      // Verify email with backend
      final verifyEmailUrl = '$apiUrl/api/SendEmail/verify-email/$email';
      final response = await http.post(
        Uri.parse(verifyEmailUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['valid'] == true) {
        // Save user to backend
        final saveUserResponse = await http.post(
          Uri.parse('$apiUrl/api/users/local/saveUser'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'uid': userCredential.user!.uid,
            'firstname': firstName,
            'lastname': lastName,
          }),
        );

        if (saveUserResponse.statusCode == 200) {
          // Fetch user data and store it
          final userData = await getUserData(userCredential.user!.uid);
          if (userData.isNotEmpty) {
            await SharedPreferences.getInstance().then((prefs) {
              prefs.setString('firstName', userData['firstName']);
              prefs.setString('lastName', userData['lastName']);
              prefs.setString('email', userData['email']);
              prefs.setString('phoneNumber', userData['phoneNumber']);
              prefs.setString('role', userData['role']);
            });
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (BuildContext context) => Home()),
          );
          return true;
        } else {
          Fluttertoast.showToast(
            msg: 'Failed to save user',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0,
          );
          return false;
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Invalid email address',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        return false;
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: formatError(e),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      return false;
    } catch (e) {
      print('Signup Error: ${e.toString()}');
      return false;
    }
  }

  Future<void> sendEmailVerification(User user) async {
    try {
      await user.sendEmailVerification();
      Fluttertoast.showToast(
        msg: 'Verification email sent. Please check your inbox.',
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

  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Attempt to sign in the user
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if the email is verified
      if (!userCredential.user!.emailVerified) {
        // If not verified, send another verification email
        await sendEmailVerification(userCredential.user!);

        Fluttertoast.showToast(
          msg:
              'Email not verified. A verification email has been sent again. Please verify your email before signing in.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0,
        );

        // Sign out the user to prevent them from accessing the app
        await _auth.signOut();
        return;
      }

      // Continue with sign-in process if email is verified
      String? idToken = await userCredential.user!.getIdToken();
      if (idToken != null) {
        // Fetch user data and store it
        final userData = await getUserData(userCredential.user!.uid);
        if (userData.isNotEmpty) {
          await SharedPreferences.getInstance().then((prefs) {
            prefs.setString('firstName', userData['firstName']);
            prefs.setString('lastName', userData['lastName']);
            prefs.setString('email', userData['email']);
            prefs.setString('phoneNumber', userData['phoneNumber']);
            prefs.setString('role', userData['role']);
          });
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', idToken);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => Home()),
        );
      } else {
        throw Exception('Failed to retrieve ID token');
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: formatError(e),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {
      print('Signin Error: ${e.toString()}');
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

  Future<void> signout({required BuildContext context}) async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwt_token');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const SignIn()),
      );
    } catch (e) {
      print('Signout Error: ${e.toString()}');
    }
  }

  String formatError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'User disabled.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'email-already-in-use':
        return 'An account already exists with that email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      default:
        return 'An undefined error occurred.';
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
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

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      String? idToken = await userCredential.user!.getIdToken();
      if (idToken != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', idToken);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => Home()),
        );
      } else {
        throw Exception('Failed to retrieve ID token');
      }
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
      final postData = {
        'email': email,
        'requestType': 'PASSWORD_RESET',
      };
      final response = await http.post(
        Uri.parse(
            'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$firebaseApiKey'),
        body: json.encode(postData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Password reset request failed');
      }
    } catch (e) {
      print('Send password reset error: ${e.toString()}');
    }
  }

  Future<void> googleSignout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Future<void> runLogoutTimer() async {
    // Implement the logout timer logic if required
  }

  Future<void> saveTokenInLocalStorage(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  Future<void> loginWithCustomToken(String token) async {
    try {
      await _auth.signInWithCustomToken(token);
    } catch (e) {
      print('Login with custom token failed: ${e.toString()}');
    }
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<Map<String, dynamic>> getUserData(String uid) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/api/users/$uid'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Get user data error: ${e.toString()}');
      return {};
    }
  }
}

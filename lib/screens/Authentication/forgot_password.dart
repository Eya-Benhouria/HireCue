// import 'package:country_code_picker/country_code_picker.dart';
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:hirecue_app/Services/auth_service.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../GlobalComponents/button_global.dart';
import '../../GlobalComponents/color_config.dart';
import '../../constant.dart';
import 'phone_verification.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _auth = AuthService();
  final _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(134, 230, 215, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(134, 230, 215, 1),
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Forgot Password',
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Enter your email to get a password reset email.',
              style: kTextStyle.copyWith(color: Colors.white),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 60.0,
                    child: AppTextField(
                      textFieldType: TextFieldType.EMAIL,
                      controller: _email,
                      enabled: true,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter Your Email',
                        labelStyle: kTextStyle,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ButtonGlobal(
                    buttontext: 'Send Email',
                    buttonDecoration: kButtonDecoration.copyWith(
                        color: ColorConfig.secondColor),
                    onPressed: () {
                      _auth.sendPasswordReset(_email.text);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:Text(
                              "An email has been sent to reset your password!")));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

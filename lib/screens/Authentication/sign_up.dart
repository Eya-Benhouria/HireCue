import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hirecue_app/screens/Authentication/sign_in.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../GlobalComponents/button_global.dart';
import '../../GlobalComponents/color_config.dart';
import '../../constant.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(134, 230, 215, 1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back when pressed
          },
        ),
        title: Text(
          'Sign Up',
          style: kTextStyle.copyWith(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(134, 230, 215, 1),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/logo.png',
                    height: 50,
                    width: 200,
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    'Sign Up now to begin an amazing journey!',
                    style: kTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const TextField(
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            hintText: 'Enter Name',
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        const TextField(
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            hintText: 'Enter Last Name',
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        AppTextField(
                          textFieldType: TextFieldType.EMAIL,
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                            hintText: 'Enter Email',
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        AppTextField(
                          textFieldType: TextFieldType.PASSWORD,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: kTextStyle,
                            hintText: 'Enter password',
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        ButtonGlobal(
                          buttontext: 'Sign Up',
                          buttonDecoration: kButtonDecoration.copyWith(
                            color: ColorConfig.secondColor,
                          ),
                          onPressed: () {
                            // HomeScreen().launch(context);
                          },
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Have an account?   ',
                              style: kTextStyle.copyWith(
                                color: kGreyTextColor,
                              ),
                            ),
                            Text(
                              'Sign In',
                              style: kTextStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ColorConfig.secondColor,
                              ),
                            ).onTap(() {
                              SignIn().launch(context);
                            }),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Or Sign Up With...',
                              style: kTextStyle.copyWith(
                                color: kGreyTextColor,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Card(
                                elevation: 2.0,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    FontAwesomeIcons.facebookF,
                                    color: Color(0xFF3B5998),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              elevation: 2.0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(
                                  'images/google.png',
                                  height: 25.0,
                                  width: 25.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Card(
                                elevation: 2.0,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    FontAwesomeIcons.twitter,
                                    color: Color(0xFF3FBCFF),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

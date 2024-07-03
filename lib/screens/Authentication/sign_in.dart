import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hirecue_app/GlobalComponents/color_config.dart';
import 'package:hirecue_app/Services/auth_service.dart';
import 'package:hirecue_app/constant.dart';
import 'package:hirecue_app/screens/Authentication/forgot_password.dart';
import 'package:hirecue_app/screens/Authentication/sign_up.dart';
// import 'package:country_code_picker/country_code_picker.dart';
// (Assuming you have the country code picker package)

import 'package:nb_utils/nb_utils.dart';

import '../../GlobalComponents/button_global.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isChecked = false;
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(134, 230, 215, 1),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30.0),
                  Image.asset(
                    'images/logo.png',
                    height: 80,
                    width: 200,
                  ),
                  Text(
                    'Welcome back!',
                    style: kTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  Container(
                    padding: const EdgeInsets.all(25.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextField(
                          obscureText: obscurePassword,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: ColorConfig.primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: isChecked,
                                thumbColor: kGreyTextColor,
                                onChanged: (bool value) {
                                  setState(() {
                                    isChecked = value;
                                  });
                                },
                              ),
                            ),
                            Text(
                              'Save Me',
                              style: kTextStyle,
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                const ForgotPassword().launch(context);
                              },
                              child: const Text(
                                'Forgot Password?',
                                style:
                                    TextStyle(color: ColorConfig.secondColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        ButtonGlobal(
                          buttontext: 'Sign In',
                          buttonDecoration: kButtonDecoration.copyWith(
                            color: ColorConfig.secondColor,
                          ),
                          onPressed: () async {
                            await AuthService().signin(
                                email: _emailController.text,
                                password: _passwordController.text,
                                context: context);
                          },
                        ),
                        const SizedBox(height: 20.0),
                        // Divider for visual separation
                        const Divider(color: Colors.grey),

                        // Sign In with Google button
                        ElevatedButton.icon(
                          onPressed: () {
                            AuthService().signInWithGoogle(context);
                          },
                          icon: Image.asset(
                            'images/google.png',
                            height: 25.0,
                            width: 25.0,
                          ),
                          label: const Text('Sign In with Google'),
                        ),
                        const SizedBox(height: 20.0),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account? ',
                              style: kTextStyle.copyWith(color: kGreyTextColor),
                            ),
                            TextButton(
                              onPressed: () {
                                const SignUp().launch(context);
                              },
                              child: Text(
                                'Sign Up',
                                style: kTextStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: ColorConfig.secondColor,
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

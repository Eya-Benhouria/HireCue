import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hirecue_app/services/auth_service.dart';
import 'package:hirecue_app/screens/Authentication/sign_in.dart';
import 'package:hirecue_app/screens/Home/home.dart';
import 'package:hirecue_app/GlobalComponents/button_global.dart';
import 'package:hirecue_app/GlobalComponents/color_config.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

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
          style: TextStyle(
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
                    style: TextStyle(
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
                        TextField(
                          controller: _firstNameController,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            labelText: 'First Name',
                            hintText: 'Enter Name',
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextField(
                          keyboardType: TextInputType.name,
                          controller: _lastNameController,
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
                            hintText: 'Enter Last Name',
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                            hintText: 'Enter Email',
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextField(
                          obscureText: true,
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter password',
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        ButtonGlobal(
                          buttontext: 'Sign Up',
                          buttonDecoration: BoxDecoration(
                            color: ColorConfig.secondColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          onPressed: () async {
                            await AuthService().signup(
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                              context: context,
                            );
                          },
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Have an account? ',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignIn(),
                                  ),
                                );
                              },
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorConfig.secondColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Or Sign Up With...',
                              style: TextStyle(
                                color: Colors.grey[600],
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
                            InkWell(
                              onTap: () async {
                                AuthService().signInWithGoogle(context);
                              },
                              child: Card(
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hirecue_app/GlobalComponents/color_config.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String firstName = '';
  String lastName = '';
  String email = '';
  String phoneNumber = '';
  String role = 'Candidate';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      // Fetch user profile from Firebase
      setState(() {
        email = user.email ?? '';
        phoneNumber = user.phoneNumber ?? '';
        // Use custom data fetch methods if you have additional user information stored in your backend
        // Example: Fetching additional details from your backend
        // final userData = await getUserDataFromBackend(user.uid);
        // firstName = userData['firstName'] ?? '';
        // lastName = userData['lastName'] ?? '';
        // role = userData['role'] ?? '';
      });
    }
  }

  Future<Map<String, String>> getUserDataFromBackend(String uid) async {
    // Fetch user data from your backend API
    // Replace with your backend API call to get user data
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    return {
      'firstName': 'John', // Replace with actual data
      'lastName': 'Doe', // Replace with actual data
      'email': 'john.doe@example.com', // Replace with actual data
      'phoneNumber': '123-456-7890', // Replace with actual data
      'role': 'Developer', // Replace with actual data
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConfig.secondColor,
      appBar: AppBar(
        backgroundColor: ColorConfig.secondColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Text(
            'Profile',
            maxLines: 2,
            style: kTextStyle.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          const Image(
            image: AssetImage('images/editprofile.png'),
          ).onTap(() {
            // Navigation or action for editing profile
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            Container(
              width: context.width(),
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  const CircleAvatar(
                    radius: 60.0,
                    backgroundColor: kMainColor,
                    backgroundImage: AssetImage('images/emp1.png'),
                  ),
                  const SizedBox(height: 20.0),
                  AppTextField(
                    readOnly: true,
                    textFieldType: TextFieldType.NAME,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      hintText: firstName,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  AppTextField(
                    readOnly: true,
                    textFieldType: TextFieldType.NAME,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      hintText: lastName,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  AppTextField(
                    readOnly: true,
                    textFieldType: TextFieldType.EMAIL,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      hintText: email,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  AppTextField(
                    textFieldType: TextFieldType.PHONE,
                    controller: TextEditingController(text: phoneNumber),
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      hintText: phoneNumber,
                      labelStyle: kTextStyle,
                      border: const OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  AppTextField(
                    readOnly: true,
                    textFieldType: TextFieldType.ADDRESS,
                    decoration: InputDecoration(
                      labelText: 'Role',
                      hintText: role,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

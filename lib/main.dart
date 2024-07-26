import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hirecue_app/screens/Home/home.dart';
import 'package:hirecue_app/screens/Splash%20Screen/splash_screen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final User? user = FirebaseAuth.instance.currentUser;

  runApp(MyApp(user: user));
}

class MyApp extends StatelessWidget {
  final User? user;

  const MyApp({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
      ),
      title: 'HireCue',
      home: user == null ? const SplashScreen() : Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

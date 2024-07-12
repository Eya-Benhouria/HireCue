import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hirecue_app/firebase_options.dart';

import 'screens/Splash Screen/splash_screen.dart';

Future<void> main() async {
  // firebse initialization
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Add the line below to get horizontal sliding transitions for routes.
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
      ),
   
      title: 'HireCue',
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

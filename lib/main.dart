import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tutor_matchup/firebase_options.dart';
import 'package:tutor_matchup/views/login_screen.dart';
import 'package:tutor_matchup/views/welcome_screen.dart';
// import 'routes/routes.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'TutorMatchup',
      debugShowCheckedModeBanner: false,
      // initialRoute: Routes.welcome,
      // routes: appRoutes,
      home: WelcomeScreen(),
    );
  }
}

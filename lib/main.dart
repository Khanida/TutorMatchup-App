import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tutor_matchup/firebase_options.dart';
import 'package:tutor_matchup/routes/routes.dart';

import 'views/student_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TutorMatchup',
      debugShowCheckedModeBanner: false,
      home: StudentHomeScreen(),
      // initialRoute: Routes.login,
      // routes: appRoutes,
      // home: UserGuidelinesScreen(),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tutor_matchup/routes/routes.dart';
import 'package:tutor_matchup/services/firebase_auth_services.dart';
import 'package:tutor_matchup/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);
  late final Animation<double> _scale = Tween<double>(
    begin: 0.96,
    end: 1,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  Timer? _navigationTimer;

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _navigationTimer = Timer(const Duration(seconds: 2), _continue);
  }

  Future<void> _continue() async {
    final auth = FirebaseAuthService();
    final user = auth.getCurrentUser();
    String? userType;
    if (user != null) {
      try {
        final profile = await auth.getUserData(user.uid);
        final role = profile?['userType'];
        if (role == 'student' || role == 'tutor') userType = role as String;
      } catch (error) {
        debugPrint('Could not restore the signed-in profile: $error');
      }
    }

    if (!mounted) return;
    if (userType == null) {
      Navigator.pushReplacementNamed(context, Routes.login);
    } else {
      Navigator.pushReplacementNamed(
        context,
        Routes.homeWrapper,
        arguments: userType,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Center(
          child: ScaleTransition(
            scale: _scale,
            child: Image.asset(
              'assets/images/tutormatchup_logo.png',
              height: 200,
              width: 200,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

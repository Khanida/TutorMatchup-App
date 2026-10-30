import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutor_matchup/routes/routes.dart';
import 'package:tutor_matchup/services/firebase_auth_services.dart';
import 'package:tutor_matchup/utils/colors.dart';
import 'package:tutor_matchup/widgets/custom_button.dart';
import 'package:tutor_matchup/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate() || _isLoading) return;
    setState(() => _isLoading = true);

    try {
      final authService = FirebaseAuthService();
      final user = await authService.login(
        _emailController.text,
        _passwordController.text,
      );
      if (user == null) {
        throw StateError('Sign-in completed without returning a user.');
      }

      final profile = await authService.getUserData(user.uid);
      final userType = profile?['userType'];
      if (userType != 'student' && userType != 'tutor') {
        await authService.signOut();
        throw StateError(
          'We could not find a valid student or tutor profile for this account.',
        );
      }

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.homeWrapper,
        (_) => false,
        arguments: userType,
      );
    } on FirebaseAuthException catch (error) {
      if (mounted) {
        final message = switch (error.code) {
          'invalid-email' => 'Enter a valid email address.',
          'user-disabled' => 'This account has been disabled.',
          'user-not-found' || 'wrong-password' || 'invalid-credential' =>
            'Email or password is incorrect.',
          'too-many-requests' => 'Too many attempts. Please try again later.',
          _ => 'Unable to sign in. Please try again.',
        };
        _showMessage(message);
      }
    } catch (error) {
      if (mounted) {
        _showMessage(error is StateError
            ? error.message
            : 'Could not load your account. Check your connection and try again.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/images/tutormatchup_logo.png',
                      height: 110,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome back',
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: midnightBlueColor,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue learning or teaching.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: coolGrayColor),
                    ),
                    const SizedBox(height: 28),
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'name@example.com',
                      labelText: 'Email',
                      textInputType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        final email = value?.trim() ?? '';
                        if (email.isEmpty ||
                            !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                .hasMatch(email)) {
                          return 'Enter a valid email address.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: 'Enter your password',
                      labelText: 'Password',
                      textInputAction: TextInputAction.done,
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.visibility_outlined),
                      ),
                      validator: (value) => (value ?? '').isEmpty
                          ? 'Enter your password.'
                          : null,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, Routes.forgotPassword),
                        child: const Text('Forgot password?'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            onTap: _signIn,
                            buttonText: 'Sign in',
                          ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'New to TutorMatchup?',
                          style: TextStyle(color: coolGrayColor),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, Routes.registeration),
                          child: const Text('Create account'),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, Routes.userGuidelines),
                      child: const Text('User guidelines'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

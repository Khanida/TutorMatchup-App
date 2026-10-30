import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tutor_matchup/routes/routes.dart';
import 'package:tutor_matchup/services/firebase_auth_services.dart';
import 'package:tutor_matchup/utils/colors.dart';

class UserGuidelinesScreen extends StatelessWidget {
  const UserGuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rawArguments = ModalRoute.of(context)?.settings.arguments;
    if (rawArguments is! Map) {
      return Scaffold(
        appBar: AppBar(title: const Text('User guidelines')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Create an account first to continue.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => Navigator.pushReplacementNamed(
                      context, Routes.registeration),
                  child: const Text('Create account'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final arguments = Map<String, dynamic>.from(rawArguments);
    final userType = arguments['userType'] as String?;
    if (userType != 'student' && userType != 'tutor') {
      return Scaffold(
        appBar: AppBar(title: const Text('User guidelines')),
        body: const Center(child: Text('Registration details are incomplete.')),
      );
    }

    return _GuidelinesContent(arguments: arguments, userType: userType!);
  }
}

class _GuidelinesContent extends StatelessWidget {
  final Map<String, dynamic> arguments;
  final String userType;

  const _GuidelinesContent({
    required this.arguments,
    required this.userType,
  });

  Future<void> _createAccount(BuildContext context) async {
    final email = arguments['email'] as String?;
    final password = arguments['password'] as String?;
    final name = arguments['name'] as String?;
    if (email == null ||
        password == null ||
        name == null ||
        email.trim().isEmpty ||
        password.isEmpty ||
        name.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration details are incomplete.')),
      );
      return;
    }

    try {
      await FirebaseAuthService().signUp(
        email: email,
        password: password,
        name: name,
        userType: userType,
        institute: arguments['institute'] as String?,
        year: arguments['year'] as String?,
        learningFormat: arguments['learningFormat'] as String?,
        preferredDays: arguments['preferredDays'] as String?,
        preferredTime: arguments['preferredTime'] as String?,
        phoneNo: arguments['phoneNo'] as String?,
        education: arguments['education'] as String?,
        availability: arguments['availability'] as String?,
        experience: arguments['experience'] as String?,
        subjects: arguments['subjects'] as String?,
        resume: arguments['resume'] as String?,
      );
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.homeWrapper,
        (_) => false,
        arguments: userType,
      );
    } on FirebaseAuthException catch (error) {
      if (!context.mounted) return;
      final message = switch (error.code) {
        'email-already-in-use' => 'An account already uses this email.',
        'invalid-email' => 'Enter a valid email address.',
        'weak-password' => 'Choose a stronger password.',
        _ => 'Unable to create your account. Please try again.',
      };
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    } catch (error) {
      debugPrint('Account creation failed: $error');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content:
                Text('Could not save your profile. Check your connection.'),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User guidelines')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Text(
              'A good learning experience starts with respect.',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: midnightBlueColor,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 18),
            const _GuidelineCard(
              icon: Icons.menu_book_outlined,
              title: 'Learn and teach responsibly',
              description:
                  'Use accurate information, communicate clearly, and keep sessions focused on learning.',
            ),
            const SizedBox(height: 12),
            const _GuidelineCard(
              icon: Icons.shield_outlined,
              title: 'Protect your privacy',
              description:
                  'Share personal information only when necessary. Treat other members respectfully and report unsafe behavior.',
            ),
            const SizedBox(height: 12),
            const _GuidelineCard(
              icon: Icons.rule_outlined,
              title: 'Use the platform fairly',
              description:
                  'By continuing, you agree to follow these guidelines and the platform policies.',
            ),
            const SizedBox(height: 20),
            AgreeButtonWithCheckbox(
              onButtonTap: () => _createAccount(context),
              text: 'I agree to the guidelines',
            ),
          ],
        ),
      ),
    );
  }
}

class _GuidelineCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _GuidelineCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: whiteColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE7ECF4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: lightBlueColor),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: midnightBlueColor,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: coolGrayColor),
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

class AgreeButtonWithCheckbox extends StatefulWidget {
  final Future<void> Function() onButtonTap;
  final String text;

  const AgreeButtonWithCheckbox({
    super.key,
    required this.onButtonTap,
    required this.text,
  });

  @override
  State<AgreeButtonWithCheckbox> createState() =>
      _AgreeButtonWithCheckboxState();
}

class _AgreeButtonWithCheckboxState extends State<AgreeButtonWithCheckbox> {
  bool _isChecked = false;
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (!_isChecked || _isSubmitting) return;
    setState(() => _isSubmitting = true);
    try {
      await widget.onButtonTap();
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: _isChecked,
          onChanged: _isSubmitting
              ? null
              : (value) => setState(() => _isChecked = value ?? false),
          title: Text(
            widget.text,
            style: const TextStyle(color: midnightBlueColor),
          ),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _isChecked && !_isSubmitting ? _submit : null,
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Create account'),
          ),
        ),
      ],
    );
  }
}

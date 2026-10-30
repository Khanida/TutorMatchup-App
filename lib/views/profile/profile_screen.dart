import 'package:flutter/material.dart';
import 'package:tutor_matchup/routes/routes.dart';
import 'package:tutor_matchup/services/firebase_auth_services.dart';
import 'package:tutor_matchup/utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final Future<Map<String, dynamic>?> _profileFuture;
  bool _isSigningOut = false;

  @override
  void initState() {
    super.initState();
    final service = FirebaseAuthService();
    final user = service.getCurrentUser();
    _profileFuture =
        user == null ? Future.value(null) : service.getUserData(user.uid);
  }

  Future<void> _signOut() async {
    if (_isSigningOut) return;
    setState(() => _isSigningOut = true);
    try {
      await FirebaseAuthService().signOut();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.login,
        (_) => false,
      );
    } catch (error) {
      debugPrint('Sign out failed: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not sign out. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _isSigningOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          TextButton(
            onPressed: _isSigningOut ? null : _signOut,
            child: _isSigningOut
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Sign out'),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('Could not load your profile. Please try again.'),
              ),
            );
          }
          final profile = snapshot.data;
          if (profile == null) {
            return const Center(child: Text('No profile is available.'));
          }
          final name = profile['name'] as String? ?? 'TutorMatchup member';
          final email = profile['email'] as String? ?? '';
          final userType = profile['userType'] as String? ?? '';
          final roleDetail = userType == 'tutor'
              ? profile['subjects'] as String? ?? 'Tutor'
              : profile['institute'] as String? ?? 'Student';

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3887F5), Color(0xFF67A5FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.white.withValues(alpha: 0.22),
                      child: Text(
                        name.trim().isEmpty
                            ? '?'
                            : name.trim()[0].toUpperCase(),
                        style: const TextStyle(
                          color: whiteColor,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: whiteColor,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userType == 'tutor' ? 'Tutor' : 'Student',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _ProfileInfoTile(
                icon: Icons.email_outlined,
                label: 'Email',
                value: email.isEmpty ? 'Not provided' : email,
              ),
              _ProfileInfoTile(
                icon: userType == 'tutor'
                    ? Icons.menu_book_outlined
                    : Icons.school_outlined,
                label: userType == 'tutor' ? 'Subjects' : 'Institute',
                value: roleDetail.isEmpty ? 'Not provided' : roleDetail,
              ),
              if (userType == 'tutor' &&
                  (profile['education'] as String?)?.isNotEmpty == true)
                _ProfileInfoTile(
                  icon: Icons.workspace_premium_outlined,
                  label: 'Education',
                  value: profile['education'] as String,
                ),
              if (userType == 'student' &&
                  (profile['year'] as String?)?.isNotEmpty == true)
                _ProfileInfoTile(
                  icon: Icons.class_outlined,
                  label: 'Grade / year',
                  value: profile['year'] as String,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: whiteColor,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE7ECF4)),
      ),
      child: ListTile(
        leading: Icon(icon, color: lightBlueColor),
        title: Text(label, style: const TextStyle(color: coolGrayColor)),
        subtitle: Text(
          value,
          style: const TextStyle(
            color: midnightBlueColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

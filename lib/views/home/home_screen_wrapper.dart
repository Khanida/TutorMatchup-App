// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:tutor_matchup/utils/colors.dart';
import 'package:tutor_matchup/views/messages/inbox_screen.dart';
import 'package:tutor_matchup/views/profile/profile_screen.dart';
import 'student_home_screen.dart';
import 'tutor_home_screen.dart'; // Import the Tutor Home Screen
import '../schedules/upcoming_schedule_screen.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int _selectedIndex = 0;
  String userType = 'student';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final argument = ModalRoute.of(context)?.settings.arguments;
    if (argument is String && (argument == 'student' || argument == 'tutor')) {
      userType = argument;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = userType == 'student'
        ? [
            const StudentHomeScreen(),
            UpcomingScheduleScreen(userRole: userType),
            const InboxScreen(),
            const ProfileScreen(),
          ]
        : [
            const TutorHomeScreen(), // Ensure TutorHomeScreen is defined
            UpcomingScheduleScreen(userRole: userType),
            const InboxScreen(),
            const ProfileScreen(),
          ];

    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(child: screens[_selectedIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        backgroundColor: whiteColor,
        indicatorColor: lightPeriwinkleColor,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today_rounded),
            label: 'Schedules',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

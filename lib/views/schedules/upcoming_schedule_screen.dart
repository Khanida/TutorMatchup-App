import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tutor_matchup/widgets/appointed_tutor_card.dart';
import '../../utils/colors.dart';
import '../../widgets/custom_text_widget.dart';
import 'package:tutor_matchup/routes/routes.dart';
import 'package:tutor_matchup/services/firebase_auth_services.dart';

class UpcomingScheduleScreen extends StatefulWidget {
  final String? userRole;

  const UpcomingScheduleScreen({super.key, this.userRole});

  @override
  State<UpcomingScheduleScreen> createState() => _UpcomingScheduleScreenState();
}

class _UpcomingScheduleScreenState extends State<UpcomingScheduleScreen> {
  String userRole = '';
  bool isLoading = true;
  String? loadError;

  List<Map<String, String>> schedules = [];

  final TextEditingController classNameController = TextEditingController();
  final TextEditingController classSubjectController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    userRole = widget.userRole ?? '';
    _loadUserRole();
  }

  void _loadDemoData() {
    schedules = List.generate(
      userRole == 'student' ? 10 : 5,
      (index) => {
        'name': userRole == 'student' ? 'Engr. Sarfaraz' : 'Class ${index + 1}',
        'date': 'Monday, 15 April',
        'time': '11:00 am - 12:00 pm',
        'subject': userRole == 'student' ? 'Mathematics' : '30 students · Maths',
      },
    );
  }

  Future<void> _loadUserRole() async {
    try {
      if (userRole.isEmpty) {
        final user = FirebaseAuthService().getCurrentUser();
        if (user != null) {
          final profile = await FirebaseAuthService().getUserData(user.uid);
          userRole = profile?['userType'] as String? ?? '';
        }
      }
      if (!mounted) return;
      setState(() {
        if (userRole == 'student' || userRole == 'tutor') {
          _loadDemoData();
        }
        isLoading = false;
      });
    } catch (error) {
      debugPrint('Could not load schedule role: $error');
      if (!mounted) return;
      setState(() {
        loadError = 'Could not load your account. Check your connection.';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    classNameController.dispose();
    classSubjectController.dispose();
    super.dispose();
  }

  void _showAddSessionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Session'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: classNameController,
                  decoration: const InputDecoration(labelText: 'Class Name'),
                ),
                TextField(
                  controller: classSubjectController,
                  decoration: const InputDecoration(labelText: 'Subject'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: _selectDate, // Open Date Picker
                  child: Text(
                    selectedDate == null
                        ? 'Select Date'
                        : DateFormat('yyyy-MM-dd').format(selectedDate!),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: _selectTime, // Open Time Picker
                  child: Text(
                    selectedTime == null
                        ? 'Select Time'
                        : selectedTime!.format(context),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_addNewSession()) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Schedule'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate && mounted) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != selectedTime && mounted) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  bool _addNewSession() {
    if (classNameController.text.trim().isEmpty ||
        classSubjectController.text.trim().isEmpty ||
        selectedDate == null ||
        selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a class name, subject, date, and time.'),
        ),
      );
      return false;
    }

    setState(() {
      schedules.add({
        'name': classNameController.text.trim(),
        'date': DateFormat('EEE, d MMM').format(selectedDate!),
        'time': selectedTime!.format(context),
        'subject': classSubjectController.text.trim(),
      });
    });

    // Clear text fields after adding
    classNameController.clear();
    classSubjectController.clear();
    selectedDate = null;
    selectedTime = null;

    // Show SnackBar confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New session added successfully!')),
    );

    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (loadError != null) {
      return Center(child: Text(loadError!));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.completedSchedules);
            },
            child: const CustomTextWidget(
              text: 'Completed',
              fontSize: 12,
              textColor: Color(0xFF8696BB),
            ),
          ),
        ],
        leadingWidth: 67,
        leading: TextButton(
          child: const CustomTextWidget(
            text: 'Missed',
            textColor: Color(0xFF8696BB),
            fontSize: 12,
          ),
          onPressed: () {
            Navigator.pushNamed(context, Routes.missedSchedules);
          },
        ),
        title: const CustomTextWidget(
          text: 'Upcoming Schedule',
          textColor: lightBlueColor,
          fontWeight: FontWeight.w500,
          fontSize: 17,
        ),
      ),
      backgroundColor: whiteColor,
      body: SafeArea(
        child: schedules.isEmpty
            ? const Center(
                child: Text('Sign in to see your upcoming schedule.'),
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: schedules.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final schedule = schedules[index];
                  return AppointedTutorCard(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.classSession);
                    },
                    name: schedule['name']!,
                    date: schedule['date']!,
                    time: schedule['time']!,
                    subjects: schedule['subject']!,
                  );
                },
              ),
      ),
      floatingActionButton: userRole == 'tutor' // Show FAB only for tutors
          ? FloatingActionButton(
              onPressed: _showAddSessionDialog,
              backgroundColor: lightBlueColor,
              child: const Icon(
                Icons.add,
                color: whiteColor,
              ),
            )
          : null, // Null means no FAB for students
    );
  }
}

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:tutor_matchup/routes/routes.dart'; // Assuming this manages routing in your app
import 'package:tutor_matchup/utils/colors.dart';
import 'package:tutor_matchup/widgets/custom_button.dart';
import 'package:tutor_matchup/widgets/custom_text_field.dart';
import 'package:tutor_matchup/widgets/custom_text_widget.dart';
import 'package:flutter/services.dart' show rootBundle;

class TutorRegistrationScreen extends StatefulWidget {
  const TutorRegistrationScreen({super.key});

  @override
  State<TutorRegistrationScreen> createState() =>
      _TutorRegistrationScreenState();
}

class _TutorRegistrationScreenState extends State<TutorRegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController availabilityController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController subjectsController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController othersEducationController =
      TextEditingController();

  List<String> subjects = [];
  String? selectedSubject;
  bool showOtherField = false;
  TextEditingController otherSubjectController = TextEditingController();

  String? selectedEducation;
  bool isOthersSelected = false;
  PlatformFile? resumeFile;
  List<String> selectedDays = [];
  bool isUploading = false;

  bool _isSubmitting = false;
  bool _isLoadingSubjects = true;

  @override
  void initState() {
    super.initState();
    loadSubjects();
  }

  Future<void> loadSubjects() async {
    try {
      final response = await rootBundle.loadString('assets/subjects.json');
      final data = json.decode(response) as List<dynamic>;
      if (!mounted) return;
      setState(() {
        subjects = data.whereType<String>().toList();
        _isLoadingSubjects = false;
      });
    } catch (error) {
      debugPrint('Could not load tutor subjects: $error');
      if (!mounted) return;
      setState(() => _isLoadingSubjects = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not load subjects. Please retry.')),
      );
    }
  }

  Future<void> _selectTimeRange() async {
    final TimeOfDay? pickedStartTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedStartTime != null && mounted) {
      final TimeOfDay? pickedEndTime = await showTimePicker(
        context: context,
        initialTime: pickedStartTime,
      );
      if (pickedEndTime != null && mounted) {
        setState(() {
          timeController.text =
              '${pickedStartTime.format(context)} - ${pickedEndTime.format(context)}';
        });
      }
    }
  }

  final List<String> educationLevels = [
    'Matriculation',
    'Intermediate',
    'Bachelor\'s Degree',
    'Master\'s Degree',
    'MPhil',
    'PhD',
    'Teaching Certificate',
    'Professional Certifications',
    'Dars-e-Nizami',
    'Alim/Alima',
    'Others',
  ];

  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  Future<String?> _uploadResume() async {
    if (resumeFile == null) return null;
    final bytes = resumeFile!.bytes;
    if (bytes == null) {
      throw StateError('The selected file could not be read.');
    }

    final extension = resumeFile!.extension?.toLowerCase();
    final contentType = switch (extension) {
      'pdf' => 'application/pdf',
      'png' => 'image/png',
      'jpg' || 'jpeg' => 'image/jpeg',
      _ => 'application/octet-stream',
    };
    final storageRef = FirebaseStorage.instance.ref().child(
        'resumes/${DateTime.now().millisecondsSinceEpoch}_${resumeFile!.name}');
    await storageRef.putData(
      bytes,
      SettableMetadata(contentType: contentType),
    );
    return storageRef.getDownloadURL();
  }

  Future<void> _pickResumeFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
        withData: true,
      );
      if (result != null && mounted) {
        final file = result.files.single;
        if (file.bytes == null) {
          throw StateError('The selected file could not be read.');
        }
        setState(() => resumeFile = file);
      }
    } catch (error) {
      debugPrint('Resume selection failed: $error');
      if (!mounted) return;
      setState(() {
        resumeFile = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not select that file. Try again.')),
      );
    }
  }

  Future<void> _registerAndNavigate() async {
    if (_isSubmitting) return;
    final isValid = nameController.text.trim().isNotEmpty &&
        emailController.text.isNotEmpty &&
        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
            .hasMatch(emailController.text.trim()) &&
        passwordController.text.length >= 6 &&
        phoneNoController.text.isNotEmpty &&
        selectedEducation != null &&
        (selectedEducation != 'Others' ||
            othersEducationController.text.trim().isNotEmpty) &&
        availabilityController.text.isNotEmpty &&
        timeController.text.isNotEmpty &&
        selectedSubject != null &&
        (selectedSubject != 'Others' ||
            otherSubjectController.text.trim().isNotEmpty);
    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete the required fields with valid information.'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      isUploading = resumeFile != null;
    });
    try {
      final resumeUrl = await _uploadResume();
      if (!mounted) return;
      final chosenSubject = selectedSubject == 'Others'
          ? otherSubjectController.text.trim()
          : selectedSubject!;
      Navigator.pushNamed(
        context,
        Routes.userGuidelines,
        arguments: {
          'userType': 'tutor',
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text,
          'phoneNo': phoneNoController.text.trim(),
          'education': selectedEducation == 'Others'
              ? othersEducationController.text.trim()
              : selectedEducation,
          'availability': availabilityController.text,
          'experience': experienceController.text,
          'subjects': chosenSubject,
          'resume': resumeUrl,
        },
      );
    } catch (error) {
      debugPrint('Tutor registration could not continue: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not upload your resume. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          isUploading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneNoController.dispose();
    availabilityController.dispose();
    experienceController.dispose();
    subjectsController.dispose();
    timeController.dispose();
    othersEducationController.dispose();
    otherSubjectController.dispose();
    super.dispose();
  }

  void _showRequiredFieldsMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Complete the required fields with valid information.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(title: const Text('Tutor registration')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                CustomTextField(
                  controller: nameController,
                  hintText: 'Enter Your Name',
                ),
                CustomTextField(
                  controller: emailController,
                  hintText: 'Email',
                  textInputType: TextInputType.emailAddress,
                ),
                CustomTextField(
                  controller: passwordController,
                  hintText: 'Password (at least 6 characters)',
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.visibility_off_outlined),
                  ),
                ),
                CustomTextField(
                  controller: phoneNoController,
                  hintText: 'Phone Number',
                  textInputType: TextInputType.phone,
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      hintText: 'Highest Level of Education',
                    ),
                    initialValue: selectedEducation,
                    items: educationLevels.map((level) {
                      return DropdownMenuItem<String>(
                        value: level,
                        child: Text(level),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedEducation = value;
                        isOthersSelected = value == 'Others';
                      });
                    },
                  ),
                ),
                if (isOthersSelected)
                  CustomTextField(
                    controller: othersEducationController,
                    hintText: 'Please specify your highest education',
                  ),
                CustomTextField(
                  controller: availabilityController,
                  hintText: 'Available Days',
                  onTap: _showDaySelectionModal,
                  readOnly: true,
                ),
                CustomTextField(
                  controller: timeController,
                  hintText: 'Preferred Time Range',
                  onTap: _selectTimeRange,
                  readOnly: true,
                ),
                CustomTextField(
                  controller: experienceController,
                  hintText: 'Previous Experience (optional)',
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _isLoadingSubjects
                          ? 'Loading subjects...'
                          : 'Subjects you teach',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: midnightBlueColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
                if (!_isLoadingSubjects)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: subjects.map((subject) {
                        return ChoiceChip(
                          label: Text(subject),
                          selected: selectedSubject == subject,
                          onSelected: (selected) {
                            setState(() {
                              selectedSubject = selected ? subject : null;
                              showOtherField = selected && subject == 'Others';
                              subjectsController.text = selected ? subject : '';
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                if (showOtherField)
                  CustomTextField(
                    controller: otherSubjectController,
                    hintText: 'Please specify your subject',
                  ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OutlinedButton.icon(
                    onPressed: _isSubmitting ? null : _pickResumeFile,
                    icon: const Icon(Icons.attach_file),
                    label: Text(resumeFile?.name ?? 'Attach resume (optional)'),
                  ),
                ),
                if (isUploading) const LinearProgressIndicator(),
                CustomButton(
                  buttonText: _isSubmitting ? 'Please wait...' : 'Continue',
                  onTap: _isSubmitting
                      ? _showRequiredFieldsMessage
                      : _registerAndNavigate,
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, Routes.login),
                  child: const Text('Already have an account? Sign in'),
                ),
              ],
            ),
          ),
        ));
  }

  void _showDaySelectionModal() {
    showModalBottomSheet(
      backgroundColor: whiteColor,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: CustomTextWidget(
                    text: 'Select Preferred Days',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    textColor: blackColor,
                  ),
                ),
                ...days.map((day) {
                  bool isSelected = selectedDays.contains(day);
                  return CheckboxListTile(
                    title: CustomTextWidget(
                      text: day,
                      textColor: blackColor,
                    ),
                    value: isSelected,
                    onChanged: (bool? value) {
                      setStateModal(() {
                        if (value == true) {
                          selectedDays.add(day);
                        } else {
                          selectedDays.remove(day);
                        }
                      });
                    },
                  );
                }),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      availabilityController.text = selectedDays.join(', ');
                    });
                    Navigator.pop(context);
                  },
                  child: const CustomTextWidget(
                    text: 'Confirm',
                    textColor: lightBlueColor,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tutor_matchup/routes/routes.dart';
import 'package:tutor_matchup/utils/colors.dart';
import 'package:tutor_matchup/widgets/custom_text_widget.dart';
import 'package:tutor_matchup/widgets/lecture_request_card.dart';
import 'package:tutor_matchup/widgets/upcomming_lecture_card.dart';

class TutorHomeScreen extends StatelessWidget {
  const TutorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your teaching hub',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: coolGrayColor),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Hi Hammad',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: midnightBlueColor,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                    IconButton.filledTonal(
                      tooltip: 'Notifications',
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none_rounded),
                    ),
                  ],
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: _TutorMetric(
                        label: 'Classes today',
                        value: '2',
                        icon: Icons.menu_book_rounded,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _TutorMetric(
                        label: 'New requests',
                        value: '6',
                        icon: Icons.inbox_rounded,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 26, 20, 14),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Upcoming classes',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: midnightBlueColor,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 172,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.84,
                        child: UpcommingLectureCard(
                          onTap: () =>
                              Navigator.pushNamed(context, Routes.classSession),
                          name: 'Class ${index + 1}',
                          availableDays: 'Monday, 16 Sept',
                          availableTime: '${index + 1}:00 pm',
                          subjects: index.isEven ? 'Mathematics' : 'Biology',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 26, 20, 14),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Lecture requests',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: midnightBlueColor,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    Text(
                      '6 waiting',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: lightBlueColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: LectureRequestCard(
                      name: 'Student ${index + 1}',
                      year: '3rd Year',
                      grade: 'CGPA 3.25',
                      institute: index.isEven
                          ? 'Mehran University'
                          : 'Sindh University',
                    ),
                  ),
                  childCount: 6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TutorMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _TutorMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7ECF4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: lightBlueColor),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: midnightBlueColor,
                  fontWeight: FontWeight.w700,
                ),
          ),
          CustomTextWidget(
            text: label,
            textColor: coolGrayColor,
            fontSize: 12,
          ),
        ],
      ),
    );
  }
}

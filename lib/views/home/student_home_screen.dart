import 'package:flutter/material.dart';
import 'package:tutor_matchup/routes/routes.dart';
import 'package:tutor_matchup/utils/colors.dart';
import 'package:tutor_matchup/widgets/near_tutor_card.dart';
import 'package:tutor_matchup/widgets/upcomming_lecture_card.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  static const _tutors = [
    {
      'name': 'Mamtaz Pawnar',
      'reviews': '4.8 (120 Reviews)',
      'location': '1.8 Km',
      'opensAt': 'Open at 4:00 pm',
      'subjects': 'Physics Specialist',
    },
    {
      'name': 'Ahmed Raza',
      'reviews': '4.9 (86 Reviews)',
      'location': '2.4 Km',
      'opensAt': 'Open at 5:30 pm',
      'subjects': 'Mathematics',
    },
    {
      'name': 'Sana Ali',
      'reviews': '4.7 (54 Reviews)',
      'location': '3.1 Km',
      'opensAt': 'Open at 3:00 pm',
      'subjects': 'Biology Specialist',
    },
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredTutors = _tutors.where((tutor) {
      final searchableText =
          '${tutor['name']} ${tutor['subjects']}'.toLowerCase();
      return searchableText.contains(_searchQuery.toLowerCase().trim());
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good to see you',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: coolGrayColor),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Hi Sana Ali',
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
                    const SizedBox(width: 8),
                    const CircleAvatar(
                      backgroundColor: lightPeriwinkleColor,
                      child: Icon(Icons.person_outline, color: lightBlueColor),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              sliver: SliverToBoxAdapter(
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    hintText: 'Search tutors or subjects',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: _SectionHeading(
                  title: 'Upcoming sessions',
                  subtitle: 'Keep your learning on track',
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 172,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  children: [
                    _upcomingSessionCard(context, 'Ahmed', 'Biology · Maths'),
                    _upcomingSessionCard(context, 'Mamtaz', 'Physics'),
                    _upcomingSessionCard(context, 'Sana', 'Chemistry'),
                  ],
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(20, 26, 20, 14),
              sliver: SliverToBoxAdapter(
                child: _SectionHeading(
                  title: 'Tutors near you',
                  subtitle: 'Find the right support for your goals',
                ),
              ),
            ),
            if (filteredTutors.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'No tutors match “$_searchQuery”. Try another name or subject.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: coolGrayColor),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final tutor = filteredTutors[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: NearTutorCard(
                          name: tutor['name']!,
                          reviews: tutor['reviews']!,
                          location: tutor['location']!,
                          opensAt: tutor['opensAt']!,
                          subjects: tutor['subjects']!,
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.tutorDetails);
                          },
                        ),
                      );
                    },
                    childCount: filteredTutors.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _upcomingSessionCard(
    BuildContext context,
    String tutorName,
    String subjects,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.84,
        child: UpcommingLectureCard(
          onTap: () => Navigator.pushNamed(context, Routes.classSession),
          name: tutorName,
          availableDays: 'Today',
          availableTime: '5:00 pm',
          subjects: subjects,
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeading({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: midnightBlueColor,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: coolGrayColor),
          ),
        ],
      ),
    );
  }
}

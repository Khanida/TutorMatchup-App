import 'package:flutter/material.dart';
import 'package:tutor_matchup/utils/colors.dart';

class NearTutorCard extends StatelessWidget {
  final String name;
  final String subjects;
  final String location;
  final String reviews;
  final String opensAt;
  final VoidCallback onPressed;

  const NearTutorCard({
    required this.name,
    required this.reviews,
    required this.location,
    required this.onPressed,
    required this.opensAt,
    required this.subjects,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: whiteColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFE7ECF4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFEAF2FF),
                  child: Icon(Icons.person_outline, color: lightBlueColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: midnightBlueColor,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subjects,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: coolGrayColor,
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'View tutor',
                  onPressed: onPressed,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  color: lightBlueColor,
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: Color(0xFFE7ECF4)),
            ),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _TutorDetail(
                  icon: Icons.star_rounded,
                  text: reviews,
                  color: amberColor,
                ),
                _TutorDetail(
                  icon: Icons.location_on_outlined,
                  text: location,
                  color: coolGrayColor,
                ),
                _TutorDetail(
                  icon: Icons.access_time_rounded,
                  text: opensAt,
                  color: lightBlueColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TutorDetail extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _TutorDetail({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: midnightBlueColor,
              ),
        ),
      ],
    );
  }
}

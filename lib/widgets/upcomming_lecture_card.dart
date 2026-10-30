import 'package:flutter/material.dart';
import 'package:tutor_matchup/utils/colors.dart';

import 'custom_text_widget.dart';

class UpcommingLectureCard extends StatelessWidget {
  final String name;
  final String subjects;
  final String availableDays;
  final String availableTime;
  final VoidCallback onTap;
  const UpcommingLectureCard(
      {required this.name,
      required this.onTap,
      required this.availableDays,
      required this.availableTime,
      required this.subjects,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3887F5), Color(0xFF67A5FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person_outline, color: whiteColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                        text: name,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        textColor: whiteColor,
                      ),
                      CustomTextWidget(
                        text: subjects,
                        fontSize: 12,
                        textColor: const Color(0xFFE5F0FF),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Open class',
                  onPressed: onTap,
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: whiteColor,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1, color: Colors.white38),
            ),
            Row(
              children: [
                Expanded(
                  child: _SessionDetail(
                    icon: Icons.calendar_month_outlined,
                    text: availableDays,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _SessionDetail(
                    icon: Icons.access_time_rounded,
                    text: availableTime,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionDetail extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SessionDetail({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

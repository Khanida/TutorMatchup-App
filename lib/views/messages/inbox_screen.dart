import 'package:flutter/material.dart';
import 'package:tutor_matchup/models/message_model.dart';
import 'package:tutor_matchup/routes/routes.dart';
import 'package:tutor_matchup/utils/colors.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: chats.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chat_bubble_outline,
                        size: 48, color: coolGrayColor.withValues(alpha: 0.7)),
                    const SizedBox(height: 12),
                    Text('Your conversations will appear here.',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: chats.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final chat = chats[index];
                return Card(
                  color: whiteColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFFE7ECF4)),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    leading: CircleAvatar(
                      backgroundColor: lightPeriwinkleColor,
                      child: Text(chat.sender.initials,
                          style: const TextStyle(
                              color: midnightBlueColor,
                              fontWeight: FontWeight.w700)),
                    ),
                    title: Text(chat.sender.name,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(chat.text,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(chat.time,
                            style: Theme.of(context).textTheme.labelSmall),
                        if (chat.unread) ...[
                          const SizedBox(height: 7),
                          const CircleAvatar(
                              radius: 4, backgroundColor: lightBlueColor),
                        ],
                      ],
                    ),
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.chat,
                      arguments: chat.sender,
                    ),
                  ),
                );
              },
            ),
    );
  }
}

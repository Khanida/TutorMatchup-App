import 'package:tutor_matchup/models/user_model.dart';

class Message {
  final User sender;
  final String time;
  final String text;
  final bool unread;

  const Message({
    required this.sender,
    required this.time,
    required this.text,
    this.unread = false,
  });
}

final List<Message> chats = [
  const Message(
    sender: sampleTutor,
    time: '5:30 PM',
    text: 'I can help you with your mathematics questions.',
    unread: true,
  ),
  const Message(
    sender: sampleStudent,
    time: '4:30 PM',
    text: 'Thanks! I would like to discuss the next lesson.',
    unread: true,
  ),
  const Message(
    sender: sampleTutorTwo,
    time: '3:30 PM',
    text: 'My availability is updated for this week.',
  ),
  const Message(
    sender: sampleTutorThree,
    time: '2:30 PM',
    text: 'Let me know which topics you want to focus on.',
  ),
];

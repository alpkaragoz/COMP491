import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String messageId;
  final String senderId;
  final String text;
  final DateTime? timestamp;

  ChatMessage({
    required this.messageId,
    required this.senderId,
    required this.text,
    this.timestamp,
  });

  factory ChatMessage.fromFirestore(Map<String, dynamic> data, String messageId) {
    var ts = data['timestamp'] as Timestamp?;
    return ChatMessage(
      messageId: messageId,
      senderId: data['senderId'],
      text: data['text'],
      timestamp: ts?.toDate(),
    );
  }
}

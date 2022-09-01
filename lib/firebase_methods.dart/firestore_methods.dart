import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_whatsapp_clone/models/message.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  sendMessage({
    required String text,
    required String reciverId,
    required String senderId,
    required DateTime time,
  }) async {
    final refMessages =
        _firestore.collection('chats/$senderId-$reciverId/messages/');
    final refMessages2 =
        _firestore.collection('chats/$reciverId-$senderId/messages/');
    Message message = Message(
        text: text, time: time, senderId: senderId, reciverId: reciverId);

    await refMessages.add(message.toJson());
    await refMessages2.add(message.toJson());
  }
}

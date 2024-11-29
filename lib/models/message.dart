import 'package:cloud_firestore/cloud_firestore.dart';

import '/models/user_model.dart';

class Message {
  final UserModel? sender;
  final UserModel? reciever;
  final String? text;
  final bool? unread;
  final DateTime? time;

  Message({
    required this.sender,
    required this.reciever,
    required this.text,
    required this.unread,
    required this.time,
  });

  static Message fromMap(Map<String, dynamic> mapData) => Message(
        sender: UserModel.fromMap(mapData['sender']),
        reciever: UserModel.fromMap(mapData['receiver']),
        text: mapData['text'] ?? 'Error',
        unread: mapData['unread'] ?? false,
        time: (mapData['time'] as Timestamp).toDate(),
      );

  toMap() {
    return {
      'sender': sender!.toMap(sender!),
      'receiver': reciever!.toMap(reciever!),
      'senderId': sender!.uid,
      'text': text,
      'unread': unread,
      'time': time?.toUtc()
    };
  }
}

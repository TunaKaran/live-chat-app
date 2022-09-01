class Message {
  final String text;
  final DateTime time;
  final String senderId;
  final String reciverId;

  Message(
      {required this.text,
      required this.time,
      required this.senderId,
      required this.reciverId});

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'reciverId': reciverId,
        'text': text,
        'time': time,
      };
}

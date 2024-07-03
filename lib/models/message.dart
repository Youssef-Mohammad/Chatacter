class Message {
  final String message;
  final String sender;
  final String receiver;
  final String? id;
  final DateTime timestamp;
  final bool isSeenByReceiver;
  final bool? isImage;

  Message(
      {required this.message,
      required this.sender,
      required this.receiver,
      this.id,
      required this.timestamp,
      required this.isSeenByReceiver,
      this.isImage});
}

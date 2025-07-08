class Notification {
  final String id;
  final String title;
  final String content;
  final bool isRead;
  final String sendAt;

  Notification({
    required this.id,
    required this.title,
    required this.content,
    required this.isRead,
    required this.sendAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      isRead: json['isRead'],
      sendAt: json['sendAt'],
    );
  }
}

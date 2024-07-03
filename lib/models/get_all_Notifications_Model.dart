class NotificationResponse {
  final bool status;
  final int code;
  final List<Notification> notifications;

  NotificationResponse({
    required this.status,
    required this.code,
    required this.notifications,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    var notificationsJson = json['data']['notifications'] as List;
    List<Notification> notificationsList = notificationsJson.map((i) => Notification.fromJson(i)).toList();

    return NotificationResponse(
      status: json['data']['status'],
      code: json['data']['code'],
      notifications: notificationsList,
    );
  }
}

class Notification {
  final int id;
  final int userId;
  final String title;
  final String body;
  final int seen;
  final String createdAt;
  final String updatedAt;

  Notification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.seen,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      body: json['body'],
      seen: json['seen'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

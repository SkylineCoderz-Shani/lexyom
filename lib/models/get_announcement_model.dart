class Announcement {
  final int id;
  final String title;
  final int groupId;
  final String createdAt;
  final String updatedAt;

  Announcement({
    required this.id,
    required this.title,
    required this.groupId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'],
      groupId: json['group_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class ApiResponse {
  final bool status;
  final int code;
  final List<Announcement> announcements;

  ApiResponse({
    required this.status,
    required this.code,
    required this.announcements,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var list = json['announcements'] as List;
    List<Announcement> announcementsList = list.map((i) => Announcement.fromJson(i)).toList();

    return ApiResponse(
      status: json['status'],
      code: json['code'],
      announcements: announcementsList,
    );
  }
}

import 'dart:convert';

// Function to parse JSON to a list of UnSeenAnnouncementModel objects
List<UnSeenAnnouncementModel> unSeenAnnouncementModelFromJson(String str) =>
    List<UnSeenAnnouncementModel>.from(json.decode(str).map((x) => UnSeenAnnouncementModel.fromJson(x)));

// Function to convert a list of UnSeenAnnouncementModel objects to JSON
String unSeenAnnouncementModelToJson(List<UnSeenAnnouncementModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UnSeenAnnouncementModel {
  UnSeenAnnouncementModel({
    required this.status,
    required this.code,
    required this.announcements,
  });

  bool status;
  int code;
  List<UnSeenAnnouncement> announcements;

  factory UnSeenAnnouncementModel.fromJson(Map<String, dynamic> json) => UnSeenAnnouncementModel(
    status: json["status"],
    code: json["code"],
    announcements: List<UnSeenAnnouncement>.from(json["announcment"].map((x) => UnSeenAnnouncement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "announcment": List<dynamic>.from(announcements.map((x) => x.toJson())),
  };
}

class UnSeenAnnouncement {
  UnSeenAnnouncement({
    required this.id,
    required this.announcementId,
    required this.groupId,
    required this.userId,
    required this.seen,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int announcementId;
  int groupId;
  int userId;
  int seen;
  DateTime createdAt;
  DateTime updatedAt;

  factory UnSeenAnnouncement.fromJson(Map<String, dynamic> json) => UnSeenAnnouncement(
    id: json["id"],
    announcementId: json["announcment_id"],
    groupId: json["group_id"],
    userId: json["user_id"],
    seen: json["seen"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "announcment_id": announcementId,
    "group_id": groupId,
    "user_id": userId,
    "seen": seen,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

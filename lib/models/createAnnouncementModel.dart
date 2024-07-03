import 'dart:convert';

List<AnnouncementModel> announcementModelFromJson(String str) => List<AnnouncementModel>.from(json.decode(str).map((x) => AnnouncementModel.fromJson(x)));
String announcementModelToJson(List<AnnouncementModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AnnouncementModel {
  AnnouncementModel({
    required this.status,
    required this.code,
    required this.announcements,
  });

  bool status;
  int code;
  List<Announcement> announcements;

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) => AnnouncementModel(
    status: json["status"],
    code: json["code"],
    announcements: List<Announcement>.from(json["announcements"].map((x) => Announcement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "announcements": List<dynamic>.from(announcements.map((x) => x.toJson())),
  };
}

class Announcement {
  Announcement({
    required this.id,
    required this.title,
    required this.groupId,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String title;
  int groupId;
  DateTime createdAt;
  DateTime updatedAt;

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
    id: json["id"],
    title: json["title"],
    groupId: json["group_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "group_id": groupId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

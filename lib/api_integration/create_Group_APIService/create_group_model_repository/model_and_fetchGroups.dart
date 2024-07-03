class GroupResponse {
  final bool status;
  final int code;
  final List<Groups> groups;

  GroupResponse({
    required this.status,
    required this.code,
    required this.groups,
  });

  factory GroupResponse.fromJson(Map<String, dynamic> json) {
    return GroupResponse(
      status: json['status'],
      code: json['code'],
      groups: (json['groups'] as List).map((group) => Groups.fromJson(group)).toList(),
    );
  }
}
class Groups {
  final int id;
  final String? img;
  final String title;
  final String description;
  final int isPrivate;
  final int timeSensitive;
  final int numberOfMembers;
  final int activeUsers;
  final List<String> profile;
  final List<Members> members;

  Groups({
    required this.id,
    this.img,
    required this.title,
    required this.description,
    required this.isPrivate,
    required this.timeSensitive,
    required this.numberOfMembers,
    required this.activeUsers,
    required this.profile,
    required this.members,
  });

  factory Groups.fromJson(Map<String, dynamic> json) {
    return Groups(
      id: json['id'] ?? 0,
      img: json['img'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isPrivate: json['is_private'] ?? 0,
      timeSensitive: json['time_sensitive'] ?? 0,
      numberOfMembers: json['number_of_members'] ?? 0,
      activeUsers: json['active_users'] ?? 0,
      profile: (json['profile'] as List?)?.map((item) => item as String).toList() ?? [],
      members: (json['members'] as List).map((member) => Members.fromJson(member)).toList(),
    );
  }
}
class Members {
  final int id;
  final int groupId;
  final int userId;
  final int isAdmin;
  final int canJoin;
  final int muted;
  final String? createdAt;
  final String? updatedAt;

  Members({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.isAdmin,
    required this.canJoin,
    required this.muted,
    this.createdAt,
    this.updatedAt,
  });

  factory Members.fromJson(Map<String, dynamic> json) {
    return Members(
      id: json['id'] ?? 0,
      groupId: json['group_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      isAdmin: json['is_admin'] ?? 0,
      canJoin: json['can_join'] ?? 0,
      muted: json['muted'] ?? 0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

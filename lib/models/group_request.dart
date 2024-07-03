class GroupRequestResponse {
  final bool status;
  final int code;
  final List<GroupRequest> groupRequests;

  GroupRequestResponse({
    required this.status,
    required this.code,
    required this.groupRequests,
  });

  factory GroupRequestResponse.fromJson(Map<String, dynamic> json) {
    List<GroupRequest> groupRequestsList = [];
    if (json['data']['join_request'] != null && json['data']['join_request']['user'] != null) {
      var groupRequestsJson = json['data']['join_request']['user'] as List;
      groupRequestsList = groupRequestsJson.map((i) => GroupRequest.fromJson(i)).toList();
    }

    return GroupRequestResponse(
      status: json['data']['status'] ?? false,
      code: json['data']['code'] ?? 0,
      groupRequests: groupRequestsList,
    );
  }
}

class GroupRequest {
  final int id;
  final int groupId;
  final int userId;
  final int isAdmin;
  final int canJoin;
  final int muted;
  final String createdAt;
  final String updatedAt;

  GroupRequest({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.isAdmin,
    required this.canJoin,
    required this.muted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GroupRequest.fromJson(Map<String, dynamic> json) {
    return GroupRequest(
      id: json['id'] ?? 0,
      groupId: json['group_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      isAdmin: json['is_admin'] ?? 0,
      canJoin: json['can_join'] ?? 0,
      muted: json['muted'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

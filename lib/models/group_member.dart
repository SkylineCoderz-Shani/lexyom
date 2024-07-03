class GroupMemberResponse {
  final bool status;
  final int code;
  final int numberOfMembers;
  final List<TopUser> topUsers;
  final List<GroupMember> groupMembers;

  GroupMemberResponse({
    required this.status,
    required this.code,
    required this.numberOfMembers,
    required this.topUsers,
    required this.groupMembers,
  });

  factory GroupMemberResponse.fromJson(Map<String, dynamic> json) {
    var topUsersList = List<TopUser>.from(json['data']['top_users'].map((x) => TopUser.fromJson(x)));
    var groupMembersList = List<GroupMember>.from(json['data']['group_member'].map((x) => GroupMember.fromJson(x)));

    // Create a map to store total_points by user id
    final topUsersMap = {for (var user in topUsersList) user.id: user.totalPoints};

    // Add total_points to group members
    for (var member in groupMembersList) {
      if (topUsersMap.containsKey(member.id)) {
        member.totalPoints = topUsersMap[member.id];
      }
    }

    return GroupMemberResponse(
      status: json['data']['status'],
      code: json['data']['code'],
      numberOfMembers: json['data']['number_of_members'],
      topUsers: topUsersList,
      groupMembers: groupMembersList,
    );
  }
}

class TopUser {
  final int id;
  final String name;
  final String profile;
  final int totalPoints;

  TopUser({
    required this.id,
    required this.name,
    required this.profile,
    required this.totalPoints,
  });

  factory TopUser.fromJson(Map<String, dynamic> json) {
    return TopUser(
      id: json['id'],
      name: json['name'],
      profile: json['profile'],
      totalPoints: json['total_points'],
    );
  }
}

class GroupMember {
  final int id;
  final String? deviceToken;
  final String profile;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String dob;
  final String? lastSeen;
  final bool isAdmin;
  int? totalPoints; // Make it nullable since not all members will have totalPoints

  GroupMember({
    required this.id,
    this.deviceToken,
    required this.profile,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.dob,
    this.lastSeen,
    required this.isAdmin,
    this.totalPoints,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      id: json['id'],
      deviceToken: json['device_token'],
      profile: json['profile'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      dob: json['dob'] ?? '',
      lastSeen: json['last_seen'],
      isAdmin: json['is_admin'] == 'yes',
      totalPoints: json['total_points'], // Initialize totalPoints as null
    );
  }
}

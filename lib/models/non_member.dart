
class NonGroupMembersResponse {
  final List<NonGroupMember> nonGroupMembers;
  final bool status;
  final int code;

  NonGroupMembersResponse({
    required this.nonGroupMembers,
    required this.status,
    required this.code,
  });

  factory NonGroupMembersResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> membersList = json['data']['non_group_members'];
    List<NonGroupMember> members = membersList.map((e) => NonGroupMember.fromJson(e)).toList();

    return NonGroupMembersResponse(
      nonGroupMembers: members,
      status: json['data']['status'],
      code: json['data']['code'],
    );
  }
}
class NonGroupMember {
  final int id;
  final String? deviceToken;
  final String profile;
  final String name;
  final String email;
  final String phone;
  final String? lastSeen;

  NonGroupMember({
    required this.id,
    this.deviceToken,
    required this.profile,
    required this.name,
    required this.email,
    required this.phone,
    this.lastSeen,
  });

  factory NonGroupMember.fromJson(Map<String, dynamic> json) {
    return NonGroupMember(
      id: json['id'],
      deviceToken: json['device_token'],
      profile: json['profile'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      lastSeen: json['last_seen'],
    );
  }
}

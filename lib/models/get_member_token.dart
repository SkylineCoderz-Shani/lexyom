import 'dart:convert';

class GroupMemberTokenResponse {
  final bool status;
  final int code;
  final List<String> memberToken;

  GroupMemberTokenResponse({
    required this.status,
    required this.code,
    required this.memberToken,
  });

  factory GroupMemberTokenResponse.fromRawJson(String str) =>
      GroupMemberTokenResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GroupMemberTokenResponse.fromJson(Map<String, dynamic> json) =>
      GroupMemberTokenResponse(
        status: json["data"]["status"] ?? false,
        code: json["data"]["code"] ?? 0,
        memberToken: List<String>.from(json["data"]["member_token"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "member_token": List<dynamic>.from(memberToken.map((x) => x)),
  };
}

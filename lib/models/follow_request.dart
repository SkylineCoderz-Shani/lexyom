import 'dart:convert';

class FollowRequest {
  int id;
  String name;
  int accepted;

  FollowRequest({
    required this.id,
    required this.name,
    required this.accepted,
  });

  factory FollowRequest.fromRawJson(String str) => FollowRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FollowRequest.fromJson(Map<String, dynamic> json) => FollowRequest(
    id: json["id"],
    name: json["name"],
    accepted: json["accepted"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "accepted": accepted,
  };
}

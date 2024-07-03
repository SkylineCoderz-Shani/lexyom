import 'dart:convert';

class LeaderBoard {
  List<RemainingTopUser> topThree;
  Map<String, RemainingTopUser> remainingTopUsers;

  LeaderBoard({
    required this.topThree,
    required this.remainingTopUsers,
  });

  factory LeaderBoard.fromRawJson(String str) => LeaderBoard.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LeaderBoard.fromJson(Map<String, dynamic> json) => LeaderBoard(
    topThree: List<RemainingTopUser>.from(json["topThree"].map((x) => RemainingTopUser.fromJson(x))),
    remainingTopUsers: (json["remainingTopUsers"] is Map)
        ? Map.from(json["remainingTopUsers"]).map((k, v) => MapEntry<String, RemainingTopUser>(k, RemainingTopUser.fromJson(v)))
        : {}, // Handle empty list case by assigning an empty map
  );

  Map<String, dynamic> toJson() => {
    "topThree": List<dynamic>.from(topThree.map((x) => x.toJson())),
    "remainingTopUsers": Map.from(remainingTopUsers).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class RemainingTopUser {
  int rank;
  int userId;
  int totalPoints;

  RemainingTopUser({
    required this.rank,
    required this.userId,
    required this.totalPoints,
  });

  factory RemainingTopUser.fromRawJson(String str) => RemainingTopUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RemainingTopUser.fromJson(Map<String, dynamic> json) => RemainingTopUser(
    rank: json["rank"],
    userId: json["user_id"],
    totalPoints: json["total_points"],
  );

  Map<String, dynamic> toJson() => {
    "rank": rank,
    "user_id": userId,
    "total_points": totalPoints,
  };
}

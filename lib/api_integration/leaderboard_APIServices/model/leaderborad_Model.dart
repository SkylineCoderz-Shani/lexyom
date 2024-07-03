class UserLeader {
  final int rank;
  final int userId;
  final int totalPoints;


  UserLeader({
    required this.rank,
    required this.userId,
    required this.totalPoints,
  });

  factory UserLeader.fromJson(Map<String, dynamic> json) {
    return UserLeader(
      rank: json['rank'] ?? 0,
      userId: json['user_id'] ?? 0,
      totalPoints: json['total_points'] ?? 0,
    );
  }

}

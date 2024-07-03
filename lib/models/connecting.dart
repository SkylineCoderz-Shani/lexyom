class Connecting {
  final int id;
  final String profile;
  final String firstName;
  final String lastName;

  Connecting({
    required this.id,
    required this.profile,
    required this.firstName,
    required this.lastName,
  });

  factory Connecting.fromJson(Map<String, dynamic> json) {
    return Connecting(
      id: json['id'] as int,
      profile: json['profile'] as String,
      firstName: json['f_name'] as String,
      lastName: json['l_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile': profile,
      'f_name': firstName,
      'l_name': lastName,
    };
  }
}

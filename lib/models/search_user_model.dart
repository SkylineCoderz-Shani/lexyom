class User {
  final int id;
  final String f_name; // Corrected property name
  final String l_name;
  final String phone;
  final String email;
  final String profile;

  User({
    required this.id,
    required this.f_name,
    required this.l_name,
    required this.phone,
    required this.email,
    required this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      f_name: json['f_name'],
      l_name: json['l_name'],
      phone: json['phone'],
      email: json['email'],
      profile: json['profile'],
    );
  }

  @override
  String toString() {
    return 'User{id: $id, f_name: $f_name, l_name: $l_name, phone: $phone, email: $email, profile: $profile}';
  }
}

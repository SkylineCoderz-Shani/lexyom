import 'dart:convert';

class UserResponse {
  final bool status;
  final int code;
  final List<SearchUser> users;

  UserResponse({
    required this.status,
    required this.code,
    required this.users,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      status: json['status'],
      code: json['code'],
      users: (json['users'] as List)
          .map((user) => SearchUser.fromJson(user))
          .toList(),
    );
  }
}

class SearchUser {
  final int id;
  final String fName;
  final String lName;
  final String phone;
  final String email;
  final String profile;

  SearchUser({
    required this.id,
    required this.fName,
    required this.lName,
    required this.phone,
    required this.email,
    required this.profile,
  });

  factory SearchUser.fromJson(Map<String, dynamic> json) {
    return SearchUser(
      id: json['id'],
      fName: json['f_name'],
      lName: json['l_name'],
      phone: json['phone'],
      email: json['email'],
      profile: json['profile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'f_name': fName,
      'l_name': lName,
      'phone': phone,
      'email': email,
      'profile': profile,
    };
  }
}

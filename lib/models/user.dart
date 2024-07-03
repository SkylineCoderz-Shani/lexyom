import 'dart:convert';

class UserResponse {
  final bool status;
  final int code;
  final UserClass user;

  UserResponse({
    required this.status,
    required this.code,
    required this.user,
  });

  factory UserResponse.fromRawJson(String str) =>
      UserResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        status: json["status"] ?? false,
        code: json["code"] ?? 0,
        user: UserClass.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "user": user.toJson(),
      };
}

class UserClass {
  final Information information;
  final More more;
  final Socials socials;

  UserClass({
    required this.information,
    required this.more,
    required this.socials,
  });

  factory UserClass.fromRawJson(String str) =>
      UserClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
        information: Information.fromJson(json["information"]),
        more: More.fromJson(json["more"]),
        socials: Socials.fromJson(json["socials"]),
      );

  Map<String, dynamic> toJson() => {
        "information": information.toJson(),
        "more": more.toJson(),
        "socials": socials.toJson(),
      };
}

class Information {
  final int id;
  final String? deviceToken;
  final String usertype;
  final String? profile;
  final String ipAddress;
  final String name;
  final String phone;
  final String email;
  final String gender;
  final String location;
  final String dob;
  final String occupation;
  final String company;
  final String points;
  final String? plan;
  final String subscribed;
  final String? isVerified;
  final DateTime? lastSeen;
  final DateTime createdAt;
  final int web3Plan;

  Information({
    required this.id,
    this.deviceToken,
    required this.usertype,
    this.profile,
    required this.ipAddress,
    required this.name,
    required this.phone,
    required this.email,
    required this.gender,
    required this.location,
    required this.dob,
    required this.occupation,
    required this.company,
    required this.points,
    this.plan,
    required this.subscribed,
    this.isVerified,
    this.lastSeen,
    required this.createdAt,
    required this.web3Plan,
  });

  factory Information.fromRawJson(String str) =>
      Information.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Information.fromJson(Map<String, dynamic> json) => Information(
        id: json["id"] ?? 0,
        deviceToken: json["device_token"],
        usertype: json["usertype"] ?? '',
        profile: json["profile"],
        ipAddress: json["IP address"] ?? '',
        name: json["name"] ?? '',
        phone: json["phone"] ?? '',
        email: json["email"] ?? '',
        gender: json["gender"] ?? '',
        location: json["location"] ?? '',
        dob: json["dob"] ?? '',
        occupation: json["occupation"] ?? '',
        company: json["company"] ?? '',
        points: json["points"] ?? '0',
        plan: json["plan"],
        subscribed: json["subscribed"] ?? '0',
        isVerified: json["is_verified"],
        lastSeen: json["last_seen"] != null
            ? DateTime.parse(json["last_seen"])
            : null,
        createdAt: DateTime.parse(json["created_at"]),
        web3Plan: json["web3_plan"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "device_token": deviceToken,
        "usertype": usertype,
        "profile": profile,
        "IP address": ipAddress,
        "name": name,
        "phone": phone,
        "email": email,
        "gender": gender,
        "location": location,
        "dob": dob,
        "occupation": occupation,
        "company": company,
        "points": points,
        "plan": plan,
        "subscribed": subscribed,
        "is_verified": isVerified,
        "last_seen": lastSeen?.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "web3_plan": web3Plan,
      };
}

class More {
  final String? hobbies;
  final String? brands;

  More({
    this.hobbies,
    this.brands,
  });

  factory More.fromRawJson(String str) => More.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory More.fromJson(Map<String, dynamic> json) => More(
        hobbies: json["hobbies"],
        brands: json["brands"],
      );

  Map<String, dynamic> toJson() => {
        "hobbies": hobbies,
        "brands": brands,
      };
}

class Socials {
  final String? instagram;
  final String? facebook;
  final String? tiktok;
  final String? linkedin;
  final String? twitter;
  final String? threads;
  final String? warpcast;
  final String? youtube;

  Socials({
    this.instagram,
    this.facebook,
    this.tiktok,
    this.linkedin,
    this.twitter,
    this.threads,
    this.warpcast,
    this.youtube,
  });

  factory Socials.fromRawJson(String str) => Socials.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Socials.fromJson(Map<String, dynamic> json) => Socials(
        instagram: json["instagram"],
        facebook: json["facebook"],
        tiktok: json["tiktok"],
        linkedin: json["linkedin"],
        twitter: json["twitter"],
        threads: json["threads"],
        warpcast: json["warpcast"],
        youtube: json["youtube"],
      );

  Map<String, dynamic> toJson() => {
        "instagram": instagram,
        "facebook": facebook,
        "tiktok": tiktok,
        "linkedin": linkedin,
        "twitter": twitter,
        "threads": threads,
        "warpcast": warpcast,
        "youtube": youtube,
      };
}

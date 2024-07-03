import 'dart:convert';

class GroupInfoResponse {
  bool? status;
  int? code;
  GroupInfo? groupInfo;
  List<Admin>? admins;
  List<Member>? members;

  GroupInfoResponse({this.status, this.code, this.groupInfo, this.admins, this.members});

  GroupInfoResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    groupInfo = json['group_info'] != null ? GroupInfo.fromJson(json['group_info']) : null;
    if (json['admins'] != null) {
      admins = <Admin>[];
      json['admins'].forEach((v) {
        admins!.add(Admin.fromJson(v));
      });
    }
    if (json['members'] != null) {
      members = <Member>[];
      json['members'].forEach((v) {
        members!.add(Member.fromJson(v));
      });
    }
  }
}

class GroupInfo {
  int? id;
  String? image;
  String? title;
  String? description;
  int? isPrivate;
  int? timeSensitive;
  String? createdAt;
  int? numberOfMembers;

  GroupInfo({this.id, this.image, this.title, this.description, this.isPrivate, this.timeSensitive, this.createdAt, this.numberOfMembers});

  GroupInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    title = json['title'];
    description = json['description'];
    isPrivate = json['is_private'];
    timeSensitive = json['time_sensitive'];
    createdAt = json['created_at'];
    numberOfMembers = json['number_of_members'];
  }
}

class Admin {
  int? id;
  String? deviceToken;
  String? profile;
  String? name;
  String? email;
  String? phone;
  String? gender;
  String? dob;
  String? lastSeen;
  String? isAdmin;
  int? totalPoints;

  Admin(
      {this.id,
        this.deviceToken,
        this.profile,
        this.name,
        this.email,
        this.phone,
        this.gender,
        this.dob,
        this.lastSeen,
        this.isAdmin,
        this.totalPoints});

  Admin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deviceToken = json['device_token'];
    profile = json['profile'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    gender = json['gender'];
    dob = json['dob'];
    lastSeen = json['last_seen'];
    isAdmin = json['is_admin'];
    totalPoints = json['total_points'];
  }
}

class Member {
  int? id;
  String? deviceToken;
  String? profile;
  String? name;
  String? email;
  String? phone;
  String? gender;
  String? dob;
  String? lastSeen;
  String? isAdmin;
  int? totalPoints;

  Member(
      {this.id,
        this.deviceToken,
        this.profile,
        this.name,
        this.email,
        this.phone,
        this.gender,
        this.dob,
        this.lastSeen,
        this.isAdmin,
        this.totalPoints});

  Member.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deviceToken = json['device_token'];
    profile = json['profile'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    gender = json['gender'];
    dob = json['dob'];
    lastSeen = json['last_seen'];
    isAdmin = json['is_admin'];
    totalPoints = json['total_points'];
  }
}

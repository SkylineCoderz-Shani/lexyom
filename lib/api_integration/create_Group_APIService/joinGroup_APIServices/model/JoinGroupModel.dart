import 'dart:convert';
/// data : {"status":true,"code":200,"group":{"img":"jqPZTGKg6nYGbFNq2n1f.jpg","title":"CoderGize Group","description":"General Discussion Group","is_private":0,"time_sensitive":0,"member":{"group_id":"5","user_id":30,"is_admin":"no","joined":"yes"}}}

JoinGroupModel joinGroupModelFromJson(String str) => JoinGroupModel.fromJson(json.decode(str));
String joinGroupModelToJson(JoinGroupModel data) => json.encode(data.toJson());
class JoinGroupModel {
  JoinGroupModel({
      Data? data,}){
    _data = data;
}

  JoinGroupModel.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  Data? _data;
JoinGroupModel copyWith({  Data? data,
}) => JoinGroupModel(  data: data ?? _data,
);
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// status : true
/// code : 200
/// group : {"img":"jqPZTGKg6nYGbFNq2n1f.jpg","title":"CoderGize Group","description":"General Discussion Group","is_private":0,"time_sensitive":0,"member":{"group_id":"5","user_id":30,"is_admin":"no","joined":"yes"}}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      bool? status, 
      num? code, 
      Group? group,}){
    _status = status;
    _code = code;
    _group = group;
}

  Data.fromJson(dynamic json) {
    _status = json['status'];
    _code = json['code'];
    _group = json['group'] != null ? Group.fromJson(json['group']) : null;
  }
  bool? _status;
  num? _code;
  Group? _group;
Data copyWith({  bool? status,
  num? code,
  Group? group,
}) => Data(  status: status ?? _status,
  code: code ?? _code,
  group: group ?? _group,
);
  bool? get status => _status;
  num? get code => _code;
  Group? get group => _group;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['code'] = _code;
    if (_group != null) {
      map['group'] = _group?.toJson();
    }
    return map;
  }

}

/// img : "jqPZTGKg6nYGbFNq2n1f.jpg"
/// title : "CoderGize Group"
/// description : "General Discussion Group"
/// is_private : 0
/// time_sensitive : 0
/// member : {"group_id":"5","user_id":30,"is_admin":"no","joined":"yes"}

Group groupFromJson(String str) => Group.fromJson(json.decode(str));
String groupToJson(Group data) => json.encode(data.toJson());
class Group {
  Group({
      String? img, 
      String? title, 
      String? description, 
      num? isPrivate, 
      num? timeSensitive, 
      Member? member,}){
    _img = img;
    _title = title;
    _description = description;
    _isPrivate = isPrivate;
    _timeSensitive = timeSensitive;
    _member = member;
}

  Group.fromJson(dynamic json) {
    _img = json['img'];
    _title = json['title'];
    _description = json['description'];
    _isPrivate = json['is_private'];
    _timeSensitive = json['time_sensitive'];
    _member = json['member'] != null ? Member.fromJson(json['member']) : null;
  }
  String? _img;
  String? _title;
  String? _description;
  num? _isPrivate;
  num? _timeSensitive;
  Member? _member;
Group copyWith({  String? img,
  String? title,
  String? description,
  num? isPrivate,
  num? timeSensitive,
  Member? member,
}) => Group(  img: img ?? _img,
  title: title ?? _title,
  description: description ?? _description,
  isPrivate: isPrivate ?? _isPrivate,
  timeSensitive: timeSensitive ?? _timeSensitive,
  member: member ?? _member,
);
  String? get img => _img;
  String? get title => _title;
  String? get description => _description;
  num? get isPrivate => _isPrivate;
  num? get timeSensitive => _timeSensitive;
  Member? get member => _member;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['img'] = _img;
    map['title'] = _title;
    map['description'] = _description;
    map['is_private'] = _isPrivate;
    map['time_sensitive'] = _timeSensitive;
    if (_member != null) {
      map['member'] = _member?.toJson();
    }
    return map;
  }

}

/// group_id : "5"
/// user_id : 30
/// is_admin : "no"
/// joined : "yes"

Member memberFromJson(String str) => Member.fromJson(json.decode(str));
String memberToJson(Member data) => json.encode(data.toJson());
class Member {
  Member({
      String? groupId, 
      num? userId, 
      String? isAdmin, 
      String? joined,}){
    _groupId = groupId;
    _userId = userId;
    _isAdmin = isAdmin;
    _joined = joined;
}

  Member.fromJson(dynamic json) {
    _groupId = json['group_id'];
    _userId = json['user_id'];
    _isAdmin = json['is_admin'];
    _joined = json['joined'];
  }
  String? _groupId;
  num? _userId;
  String? _isAdmin;
  String? _joined;
Member copyWith({  String? groupId,
  num? userId,
  String? isAdmin,
  String? joined,
}) => Member(  groupId: groupId ?? _groupId,
  userId: userId ?? _userId,
  isAdmin: isAdmin ?? _isAdmin,
  joined: joined ?? _joined,
);
  String? get groupId => _groupId;
  num? get userId => _userId;
  String? get isAdmin => _isAdmin;
  String? get joined => _joined;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['group_id'] = _groupId;
    map['user_id'] = _userId;
    map['is_admin'] = _isAdmin;
    map['joined'] = _joined;
    return map;
  }

}
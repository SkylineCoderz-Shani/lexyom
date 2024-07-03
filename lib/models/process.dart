import 'dart:convert';

class Process {
  Data data;

  Process({
    required this.data,
  });

  factory Process.fromRawJson(String str) => Process.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Process.fromJson(Map<String, dynamic> json) => Process(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  bool status;
  int code;
  ProcessClass process;

  Data({
    required this.status,
    required this.code,
    required this.process,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"],
    code: json["code"],
    process: json["process"] != null ? ProcessClass.fromJson(json["process"]) : ProcessClass.empty(),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "process": process.toJson(),
  };
}

class ProcessClass {
  String title;
  String description;
  int totalPoints;
  int completedPoints;
  double completionPercentage;
  List<Point> points;

  ProcessClass({
    required this.title,
    required this.description,
    required this.totalPoints,
    required this.completedPoints,
    required this.completionPercentage,
    required this.points,
  });

  factory ProcessClass.fromRawJson(String str) => ProcessClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProcessClass.fromJson(Map<String, dynamic> json) => ProcessClass(
    title: json["title"] ?? '',
    description: json["description"] ?? '',
    totalPoints: json["totalPoints"] ?? 0,
    completedPoints: json["completedPoints"] ?? 0,
    completionPercentage: json["completionPercentage"]?.toDouble() ?? 0.0,
    points: json["points"] != null ? List<Point>.from(json["points"].map((x) => Point.fromJson(x))) : [],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "totalPoints": totalPoints,
    "completedPoints": completedPoints,
    "completionPercentage": completionPercentage,
    "points": List<dynamic>.from(points.map((x) => x.toJson())),
  };

  factory ProcessClass.empty() => ProcessClass(
    title: '',
    description: '',
    totalPoints: 0,
    completedPoints: 0,
    completionPercentage: 0.0,
    points: [],
  );
}


class Point {
  int id;
  String title;
  String description;
  String? link;
  String completed;

  Point({
    required this.id,
    required this.title,
    required this.description,
    this.link,
    required this.completed,
  });

  factory Point.fromRawJson(String str) => Point.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Point.fromJson(Map<String, dynamic> json) => Point(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    link: json["link"],
    completed: json["completed"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "link": link,
    "completed": completed,
  };
}

import 'dart:convert';

class Category {
  String icon;
  String name;
  String description;
  List<Point> points;

  Category({
    required this.icon,
    required this.name,
    required this.description,
    required this.points,
  });

  factory Category.fromRawJson(String str) => Category.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    icon: json["icon"],
    name: json["name"],
    description: json["description"],
    points: List<Point>.from(json["points"].map((x) => Point.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "icon": icon,
    "name": name,
    "description": description,
    "points": List<dynamic>.from(points.map((x) => x.toJson())),
  };
}

class Point {
  int id;
  int categoryId;
  String img;
  String title;
  String text;
  String link;
  DateTime createdAt;
  DateTime updatedAt;

  Point({
    required this.id,
    required this.categoryId,
    required this.img,
    required this.title,
    required this.text,
    required this.link,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Point.fromRawJson(String str) => Point.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Point.fromJson(Map<String, dynamic> json) => Point(
    id: json["id"],
    categoryId: json["category_id"],
    img: json["img"],
    title: json["title"],
    text: json["text"],
    link: json["link"] ,
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "img": img,
    "title": title,
    "text": text,
    "link": link,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

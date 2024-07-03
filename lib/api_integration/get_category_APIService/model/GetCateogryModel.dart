
class ApiResponse {
  bool status;
  int code;
  List<Category> category;

  ApiResponse({required this.status, required this.code, required this.category});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      code: json['code'],
      category: (json['category'] as List).map((e) => Category.fromJson(e)).toList(),
    );
  }

}

class Category {
  String icon;
  String name;
  String description;
  List<Point> points;

  Category({required this.icon, required this.name, required this.description, required this.points});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      icon: json['icon'],
      name: json['name'],
      description: json['description'],
      points: (json['points'] as List).map((e) => Point.fromJson(e)).toList(),
    );
  }
}

class Point {
  int id;
  String title;
  String text;
  String link;

  Point({
    required this.id,
    required this.title,
    required this.text,
    required this.link,
  });

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      id: json['id'],
      title: json['title'],
      text: json['text'],
      link: json['link'],
    );
  }
}

class Group {
  final int id;
  final String img;
  final String title;
  final String description;
  final int isPrivate;
  final int timeSensitive;
  final String createdAt;
  final String updatedAt;

  Group({
    required this.id,
    required this.img,
    required this.title,
    required this.description,
    required this.isPrivate,
    required this.timeSensitive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      img: json['img'] ?? '',
      title: json['title'],
      description: json['description'],
      isPrivate: json['is_private'],
      timeSensitive: json['time_sensitive'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  @override
  String toString() {
    return 'Group{id: $id, img: $img, title: $title, description: $description, isPrivate: $isPrivate, timeSensitive: $timeSensitive, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

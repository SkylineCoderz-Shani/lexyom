import 'dart:convert';

class Plan {
  int id;
  String name;
  String monthlyPrice;
  String? monthlyStripePlan;
  String yearlyPrice;
  String? yearlyStripePlan;
  List<String> points;

  Plan({
    required this.id,
    required this.name,
    required this.monthlyPrice,
    this.monthlyStripePlan,
    required this.yearlyPrice,
    this.yearlyStripePlan,
    required this.points,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    id: json["id"] as int,
    name: json["name"] as String,
    monthlyPrice: json["monthly_price"] as String,
    monthlyStripePlan: json["monthly_stripe_plan"] as String?,
    yearlyPrice: json["yearly_price"] as String,
    yearlyStripePlan: json["yearly_stripe_plan"] as String?,
    points: List<String>.from(json["points"].map((x) => x as String)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "monthly_price": monthlyPrice,
    "monthly_stripe_plan": monthlyStripePlan,
    "yearly_price": yearlyPrice,
    "yearly_stripe_plan": yearlyStripePlan,
    "points": List<dynamic>.from(points.map((x) => x)),
  };
}

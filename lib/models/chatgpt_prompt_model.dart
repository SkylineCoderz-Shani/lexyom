import 'dart:convert';

class ChatPromptResponse {
  bool status;
  int code;
  List<ChatPrompt> chatPrompts;

  ChatPromptResponse({
    required this.status,
    required this.code,
    required this.chatPrompts,
  });

  factory ChatPromptResponse.fromRawJson(String str) => ChatPromptResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatPromptResponse.fromJson(Map<String, dynamic> json) => ChatPromptResponse(
    status: json["status"],
    code: json["code"],
    chatPrompts: List<ChatPrompt>.from(json["ChatPrompt"].map((x) => ChatPrompt.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "ChatPrompt": List<dynamic>.from(chatPrompts.map((x) => x.toJson())),
  };
}

class ChatPrompt {
  int id;
  String prompt;
  String explanation;
  DateTime? createdAt;
  DateTime? updatedAt;

  ChatPrompt({
    required this.id,
    required this.prompt,
    required this.explanation,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatPrompt.fromRawJson(String str) => ChatPrompt.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatPrompt.fromJson(Map<String, dynamic> json) => ChatPrompt(
    id: json["id"],
    prompt: json["prompt"],
    explanation: json["explanation"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "prompt": prompt,
    "explanation": explanation,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

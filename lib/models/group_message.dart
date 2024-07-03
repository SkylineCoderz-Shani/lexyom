import 'dart:convert';
import 'package:http/http.dart' as http;

class GroupMessagesResponse {
  final bool status;
  final int code;
  final User user;
  final List<Message> messages;

  GroupMessagesResponse({
    required this.status,
    required this.code,
    required this.user,
    required this.messages,
  });

  factory GroupMessagesResponse.fromJson(Map<String, dynamic> json) {
    return GroupMessagesResponse(
      status: json['data']['status'],
      code: json['data']['code'],
      user: User.fromJson(json['data']['user']),
      messages: List<Message>.from(json['data']['messages'].map((x) => Message.fromJson(x))),
    );
  }
}

class User {
  final int id;
  final String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Message {
  final int id;
  final String content;
  final String status;
  final bool hasAttachment;
  final bool isDeleted;
  final AttachmentDetails? attachmentDetails;

  Message({
    required this.id,
    required this.content,
    required this.status,
    required this.hasAttachment,
    required this.isDeleted,
    this.attachmentDetails,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'] ?? '',
      status: json['status'],
      hasAttachment: json['has_attachment'],
      isDeleted: json['is_deleted'],
      attachmentDetails: json['attachment_details'] != null
          ? AttachmentDetails.fromJson(json['attachment_details'])
          : null,
    );
  }
}

class AttachmentDetails {
  final int messageId;
  final int userId;
  final String type;
  final String fileName;
  final String mimeType;
  final String size;

  AttachmentDetails({
    required this.messageId,
    required this.userId,
    required this.type,
    required this.fileName,
    required this.mimeType,
    required this.size,
  });

  factory AttachmentDetails.fromJson(Map<String, dynamic> json) {
    return AttachmentDetails(
      messageId: json['message_id'],
      userId: json['user_id'],
      type: json['type'],
      fileName: json['file_name'],
      mimeType: json['mime_type'],
      size: json['size'],
    );
  }
}

import 'dart:convert';

class SettingsResponse {
  final bool status;
  final int code;
  final Setting setting;

  SettingsResponse({
    required this.status,
    required this.code,
    required this.setting,
  });

  factory SettingsResponse.fromJson(Map<String, dynamic> json) {
    return SettingsResponse(
      status: json['status'],
      code: json['code'],
      setting: Setting.fromJson(json['setting']),
    );
  }
}

class Setting {
  final int id;
  final String nftWebsite;
  final String ownerPlan;
  final String minNft;
  final String incrementPointGroup;
  final String incrementPointChat;
  final String? chatgptApi;
  final DateTime? createdAt;
  final DateTime updatedAt;

  Setting({
    required this.id,
    required this.nftWebsite,
    required this.ownerPlan,
    required this.minNft,
    required this.incrementPointGroup,
    required this.incrementPointChat,
    this.chatgptApi,
    this.createdAt,
    required this.updatedAt,
  });

  factory Setting.fromJson(Map<String, dynamic> json) {
    return Setting(
      id: json['id'],
      nftWebsite: json['nft_website'],
      ownerPlan: json['owner_plan'],
      minNft: json['min_nft'],
      incrementPointGroup: json['increment_point_group'],
      incrementPointChat: json['increment_point_chat'],
      chatgptApi: json['chatgpt_api'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

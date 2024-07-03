
import 'message.dart';

class LastMessage {
  String sender, lastMessage;
  int timestamp,counter;
  String chatRoomId;
  String status;
  MessageType type;

//<editor-fold desc="Data Methods">

  LastMessage({
    required this.sender,
    required this.lastMessage,
    required this.timestamp,
    required this.counter,
    required this.chatRoomId,
    required this.status,
    required this.type,
  });

//<ed@override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is LastMessage &&
              runtimeType == other.runtimeType &&
              sender == other.sender &&
              lastMessage == other.lastMessage &&
              timestamp == other.timestamp &&
              counter == other.counter &&
              chatRoomId == other.chatRoomId &&
              status == other.status &&
              type == other.type
          );


  @override
  int get hashCode =>
      sender.hashCode ^
      lastMessage.hashCode ^
      timestamp.hashCode ^
      counter.hashCode ^
      chatRoomId.hashCode ^
      status.hashCode ^
      type.hashCode;


  @override
  String toString() {
    return 'LastMessage{' +
        ' sender: $sender,' +
        ' lastMessage: $lastMessage,' +
        ' timestamp: $timestamp,' +
        ' counter: $counter,' +
        ' chatRoomId: $chatRoomId,' +
        ' status: $status,' +
        ' type: $type,' +
        '}';
  }


  LastMessage copyWith({
    String? sender,
    String? lastMessage,
    int? timestamp,
    int? counter,
    String? chatRoomId,
    String? status,
    MessageType? type,
  }) {
    return LastMessage(
      sender: sender ?? this.sender,
      lastMessage: lastMessage ?? this.lastMessage,
      timestamp: timestamp ?? this.timestamp,
      counter: counter ?? this.counter,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      status: status ?? this.status,
      type: type ?? this.type,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'sender': this.sender,
      'lastMessage': this.lastMessage,
      'timestamp': this.timestamp,
      'counter': this.counter,
      'chatRoomId': this.chatRoomId,
      'status': this.status,
      "type": type.index,
    };
  }

  factory LastMessage.fromMap(Map<String, dynamic> map) {
    return LastMessage(
      sender: map['sender'] as String,
      lastMessage: map['lastMessage'] as String,
      timestamp: map['timestamp'] as int,
      counter: map['counter'] as int,
      chatRoomId: map['chatRoomId'] as String,
      status: map['status'] as String,
      type: MessageType.values[map["type"]],
    );
  }


  //</editor-fold>


}

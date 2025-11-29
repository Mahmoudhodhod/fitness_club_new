import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

enum MessageType { text, image, audio }

@JsonSerializable()
class Message extends Equatable {
  final String id;

  final String content;

  final MessageType type;

  final ChatUser sender;

  final int timeStamp;

  @JsonKey(required: false, defaultValue: false)
  final bool? sentByAdmin;

  Message({
    required this.id,
    required this.content,
    required this.type,
    required this.sender,
    required this.timeStamp,
    this.sentByAdmin,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  @override
  List<Object?> get props {
    return [
      id,
      content,
      type,
      sender,
      timeStamp,
      sentByAdmin,
    ];
  }

  @override
  bool? get stringify => true;
}

@JsonSerializable()
class ChatUser extends Equatable {
  final int id;
  final String? image;
  final String? name;
  final String? fcmToken;

  const ChatUser({
    required this.id,
    this.image,
    this.name,
    this.fcmToken,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) =>
      _$ChatUserFromJson(json);

  Map<String, dynamic> toJson() => _$ChatUserToJson(this);

  @override
  List<Object?> get props => [image, name, id, fcmToken];

  @override
  bool? get stringify => true;
}

class ChatMessage {
  final String? content;
  final MessageType type;

  ///Has an effect only when using witin [AdminChat].
  ///
  final String? roomID;

  ChatMessage({
    this.content,
    required this.type,
    this.roomID,
  });

  ChatMessage copyWith({
    String? content,
    MessageType? type,
    String? roomID,
  }) {
    return ChatMessage(
      content: content ?? this.content,
      type: type ?? this.type,
      roomID: roomID ?? this.roomID,
    );
  }
}

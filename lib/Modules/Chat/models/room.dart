import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'message.dart';

part 'room.g.dart';

@JsonSerializable()
class Room extends Equatable {
  @JsonKey(name: 'room_id')
  final String id;

  final ChatUser user;

  final Message? latestMessage;

  const Room({
    required this.id,
    required this.user,
    this.latestMessage,
  });

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  Map<String, dynamic> toJson() => _$RoomToJson(this);

  @override
  List<Object?> get props => [user, latestMessage];
}

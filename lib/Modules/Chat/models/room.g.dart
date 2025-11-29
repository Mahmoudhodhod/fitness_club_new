// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Room',
      json,
      ($checkedConvert) {
        final val = Room(
          id: $checkedConvert('room_id', (v) => v as String),
          user: $checkedConvert(
              'user', (v) => ChatUser.fromJson(v as Map<String, dynamic>)),
          latestMessage: $checkedConvert(
              'latest_message',
              (v) => v == null
                  ? null
                  : Message.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {'id': 'room_id', 'latestMessage': 'latest_message'},
    );

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'room_id': instance.id,
      'user': instance.user.toJson(),
      'latest_message': instance.latestMessage?.toJson(),
    };

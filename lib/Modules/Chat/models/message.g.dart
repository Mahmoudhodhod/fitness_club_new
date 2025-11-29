// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Message',
      json,
      ($checkedConvert) {
        final val = Message(
          id: $checkedConvert('id', (v) => v as String),
          content: $checkedConvert('content', (v) => v as String),
          type: $checkedConvert(
              'type', (v) => $enumDecode(_$MessageTypeEnumMap, v)),
          sender: $checkedConvert(
              'sender', (v) => ChatUser.fromJson(v as Map<String, dynamic>)),
          timeStamp: $checkedConvert('time_stamp', (v) => (v as num).toInt()),
          sentByAdmin:
              $checkedConvert('sent_by_admin', (v) => v as bool? ?? false),
        );
        return val;
      },
      fieldKeyMap: const {
        'timeStamp': 'time_stamp',
        'sentByAdmin': 'sent_by_admin'
      },
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'sender': instance.sender.toJson(),
      'time_stamp': instance.timeStamp,
      'sent_by_admin': instance.sentByAdmin,
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
  MessageType.audio: 'audio',
};

ChatUser _$ChatUserFromJson(Map<String, dynamic> json) => $checkedCreate(
      'ChatUser',
      json,
      ($checkedConvert) {
        final val = ChatUser(
          id: $checkedConvert('id', (v) => (v as num).toInt()),
          image: $checkedConvert('image', (v) => v as String?),
          name: $checkedConvert('name', (v) => v as String?),
          fcmToken: $checkedConvert('fcm_token', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'fcmToken': 'fcm_token'},
    );

Map<String, dynamic> _$ChatUserToJson(ChatUser instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'name': instance.name,
      'fcm_token': instance.fcmToken,
    };

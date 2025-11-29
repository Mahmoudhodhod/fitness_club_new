import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:authentication/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:the_coach/Helpers/logger.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Modules/Chat/_utilites.dart';

import '../../../Helpers/access_token_firebase.dart';
import '../models/models.dart';
import 'interface.dart';

class NullRoomID implements Exception {}

class AdminChat implements Chat {
  final User user;
  final FirebaseFirestore _firestore;

  AdminChat({
    required this.user,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  AuthRepository? _authRepository;
  set auth(AuthRepository repository) => _authRepository = repository;

  DocumentReference<Map<String, dynamic>> _roomDoc(String roomID) {
    return _firestore.collection(ROOMS_COLLECTION).doc(roomID);
  }

  CollectionReference<Map<String, dynamic>> _messagesCollection(String roomID) {
    return _roomDoc(roomID).collection(MESSAGES_COLLECTION);
  }

  @override
  Future<void> sendTextMessage(ChatMessage message) async {
    if (message.type != MessageType.text) throw InvalidSendFunction();
    if (message.content == null)
      throw AppException('Null message content is not alowed');
    return _createNewMessage(message);
  }

  @override
  Future<void> sendFileMessage(ChatMessage message,
      {required File file}) async {
    try {
      if (message.type == MessageType.text) throw InvalidSendFunction();
      final token = await _authRepository?.getUserToken();
      if (token == null) throw AppException('Token can\'t be null');
      final url = await uploadChatFile(token, file: file);
      return _createNewMessage(message.copyWith(content: url));
    } catch (e, stacktrace) {
      appLogger.e(e, e, stacktrace);
      throw UplaodingFileFailure();
    }
  }

  Future<void> _createNewMessage(ChatMessage message) {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    if (message.roomID == null) throw NullRoomID();

    final doc = _messagesCollection(message.roomID!).doc();

    final timeStamp = Timestamp.now().millisecondsSinceEpoch;
    final rMessage = Message(
      id: doc.id,
      content: message.content!,
      type: message.type,
      timeStamp: timeStamp,
      sender: user.toChatUser(isLogout: true),
      sentByAdmin: true,
    );
    batch.set(doc, rMessage.toJson());

    final room = _roomDoc(message.roomID!);
    batch.update(room, {'latest_message': rMessage.toJson()});
    room.get().then((value) async {
      String fcm = value.data()?['user']['fcm_token'];
      AccessTokenFirebase accessTokenFirebase = AccessTokenFirebase();
      String token = await accessTokenFirebase.getAccessToken();
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token
      };
      var data = json.encode({
        "message": {
          "token": fcm,
          'notification': {},
          "data": {
            "body": message.type == MessageType.text
                ? message.content
                : message.type.name,
            "title": "رسالة جديدة"
          }
        }
      });

      var dio = Dio();
      var response = await dio.request(
        'https://fcm.googleapis.com/v1/projects/fitness-clubeg/messages:send',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        print(json.encode(response.data));
      } else {
        print(response.statusMessage);
      }
    });

    return batch.commit();
  }

  Stream<QuerySnapshot<Object?>> watchChat(String roomID) {
    return _messagesCollection(roomID)
        .orderBy('time_stamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Object?>> watchRooms() {
    return _firestore
        .collection(ROOMS_COLLECTION)
        .orderBy(FieldPath.fromString('latest_message.time_stamp'),
            descending: true)
        .snapshots();
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
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

class ClientChat implements Chat {
  final User user;
  final FirebaseFirestore _firestore;

  ClientChat({
    required this.user,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  String get uid => user.uuid;

  AuthRepository? _authRepository;
  set auth(AuthRepository repository) => _authRepository = repository;

  DocumentReference<Map<String, dynamic>> get _roomDoc {
    return _firestore.collection(ROOMS_COLLECTION).doc(uid);
  }

  CollectionReference<Map<String, dynamic>> get _messagesCollection {
    return _roomDoc.collection(MESSAGES_COLLECTION);
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

  Future<void> _createNewMessage(ChatMessage message) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    final doc = _messagesCollection.doc();

    final timeStamp = Timestamp.now().millisecondsSinceEpoch;
    final chatUser = user.toChatUser(isLogout: false);
    final rMessage = Message(
      id: doc.id,
      content: message.content!,
      type: message.type,
      timeStamp: timeStamp,
      sender: chatUser,
    );

    batch.set(doc, rMessage.toJson());

    final room = _roomDoc;

    // batch.set(room, <String, dynamic>{
    //   'latest_message': rMessage.toJson(),
    //   'room_id': room.id,
    //   'user': chatUser.toJson(),
    // });
    batch.set(
      room,
      Room(
        id: room.id,
        user: chatUser,
        latestMessage: rMessage,
      ).toJson(),
    );
    return batch.commit();
  }

  Stream<QuerySnapshot<Object?>> watchChat() {
    return _messagesCollection
        .orderBy('time_stamp', descending: true)
        .snapshots();
  }
}

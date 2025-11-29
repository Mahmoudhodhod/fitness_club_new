import 'dart:io';

import 'package:authentication/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:the_coach/Modules/Chat/chat_module.dart';
import 'package:the_coach/Helpers/logger.dart';
import 'package:the_coach/Widgets/Chat/chat.dart';
import 'package:utilities/utilities.dart';

part 'chat_state.dart';

class NotInitializedException extends AppException {}

///A chat controller.
///
///You must call [init(User)] or when using any method it will throw [NotInitializedException] exciption.
///
class ChatCubit extends Cubit<ChatState> {
  User? _user;
  final AuthRepository _authRepository;
  ClientChat? _client;
  AdminChat? _admin;

  ChatCubit(this._authRepository) : super(const ChatState());

  void init(User user) {
    _user = user;
    if (_user!.role == UserRole.admin) {
      _admin = AdminChat(user: user);
      _admin!.auth = _authRepository;
    } else {
      _client = ClientChat(user: user);
      _client!.auth = _authRepository;
    }
    appLogger.d("🎉 Chat cubit was initialized");
  }

  void sendMessage(ChatMessage message, {File? file}) async {
    _assertion();
    final chat = _client == null ? _admin : _client;
    assert(chat != null);
    emit(state.copyWith(state: ChatS.sending, messageType: message.type));
    try {
      if (file != null) {
        await chat!.sendFileMessage(message, file: file);
      } else {
        await chat!.sendTextMessage(message);
      }
      emit(state.copyWith(state: ChatS.sent));
    } catch (e) {
      emit(state.copyWith(state: ChatS.failed, companion: e));
    }
  }

  Stream<QuerySnapshot<Object?>> watchRooms() {
    assert(_admin != null);
    return _admin!.watchRooms();
  }

  Stream<QuerySnapshot<Object?>> watchChat([String? roomID]) {
    if (roomID != null) {
      assert(_admin != null);
      return _admin!.watchChat(roomID);
    }
    return _client!.watchChat();
  }

  static Room roomFromDoc(DocumentSnapshot<Object?> doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Room.fromJson(data);
  }

  static Message fromDoc(DocumentSnapshot<Object?> doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Message.fromJson(data);
  }

  BubbleType getBubbleType(Message message) {
    _assertion();
    final senderID = message.sender.id;
    // log("message: ${message.content} || ${_user!.id} <== $senderID");
    return _user!.id == senderID
        ? BubbleType.sendBubble
        : BubbleType.receiverBubble;
  }

  void _assertion() {
    if (_user == null) throw NotInitializedException();
  }
}

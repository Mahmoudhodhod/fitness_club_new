import 'dart:io';

import '../models/models.dart';

abstract class Chat {
  Future<void> sendTextMessage(ChatMessage message);

  Future<void> sendFileMessage(ChatMessage message, {required File file});
}

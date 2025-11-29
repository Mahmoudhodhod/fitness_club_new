import 'dart:io';
import 'package:authentication/authentication.dart';
import 'package:preferences_utilities/preferences_utilities.dart';
import 'package:the_coach/Modules/Chat/chat_module.dart';
import 'package:utilities/utilities.dart';
import 'package:dio/dio.dart';

const ROOMS_COLLECTION = 'rooms';
const MESSAGES_COLLECTION = 'messages';

class UplaodingFileFailure implements Exception {}

class InvalidSendFunction implements Exception {}

///Uploads a chat file to the back-end.
///
///* [File] is the uploaded file and must exist or an [AppException] will be thrown.
///
Future<String> uploadChatFile(String token,
    {required File file, Dio? dio}) async {
  Future<void> _assert(File file) async {
    final exist = await file.exists();
    if (exist) return;
    throw AppException('File was not found, path: ${file.path}');
  }

  await _assert(file);
  final _dio = (dio ?? Dio());
  final f = await MultipartFile.fromFile(file.path);
  final formData = FormData.fromMap({'file': f});
  final response = await _dio.postUri(
    ChatNetworking.uploadFile,
    options: commonOptionsWithAuthHeader(token),
    data: formData,
  );
  final body = response.data;
  return body['path'];
}

extension ToChatUser on User {
  ChatUser toChatUser({required bool isLogout}) {
    return ChatUser(
      id: this.id,
      image: this.profileImagePath,
      name: this.name,
      fcmToken: isLogout
          ? ''
          : PreferencesUtilities.instance?.getValueWithKey('fcm') ?? '',
    );
  }
}

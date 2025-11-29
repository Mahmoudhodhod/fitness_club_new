import 'package:dio/dio.dart';
import 'package:flutter/material.dart' show VoidCallback;

typedef BooleanCheck = Future<bool> Function();

///Registers new email verification request interceptor to check wheather the user
///have to verify his email first before creating any api request.
///
///* [tokenExpired] called to check if the current user token has expired or not.
///
///* [onTokenExpired] called when the token has expired and the user have to verify his E-mail
///to continue.
///
Interceptor registerUserEmailVerificationNetworkInterceptor({
  required BooleanCheck tokenExpired,
  required VoidCallback onTokenExpired,
}) {
  return InterceptorsWrapper(
    onError: (e, handler) async {
      final statusCode = e.response?.statusCode;
      if (statusCode != 401) return handler.next(e);
      final isTokenExpired = await tokenExpired.call();
      if (!isTokenExpired) return handler.next(e);
      //? Token has expired and needs to be renewed
      onTokenExpired.call();
      handler.next(e);
    },
  );
}

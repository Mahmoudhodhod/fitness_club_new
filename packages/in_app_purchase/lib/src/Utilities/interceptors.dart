//TODO: create a request interceptor to check the subscription status
//TODO: edit in release

import 'package:dio/dio.dart' hide VoidCallback;
import 'package:flutter/material.dart' show VoidCallback;
import 'package:in_app_purchase/in_app_purchase.dart';

//{beta version} this method can be only used in beta testing and not for release
void registerSubscriptionInfoStatusInterceptor(
  Dio dio, {
  required IAPController controller,
  required VoidCallback onSubscriptionFailure,
}) {
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final subscriptionInfo = await controller.fetchPurchaserInfo();
        if (subscriptionInfo == null) {
          final isInFreeTrial = !(await controller.isUserFreeTrialEnded());
          if (isInFreeTrial) {
            return handler.next(options);
          }
        } else if (subscriptionInfo.isActive) {
          return handler.next(options);
        }
        onSubscriptionFailure();
        return handler.reject(DioError(requestOptions: options, type: DioErrorType.cancel));
      },
    ),
  );
}

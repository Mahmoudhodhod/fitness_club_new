import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logger/logger.dart';
import 'package:the_coach/Helpers/logger.dart';

Future<bool> isCurrentUserVIP(BuildContext context) async {
  final user = context.read<FetchDataCubit>().state.user;
  final isAdmin = user.isAdmin;
  if (isAdmin) return Future.value(true);
  appLogger
      .d('user.isLoggedIn ${context.read<FetchSubscriptionInfoCubit>().state}');
  return await context.read<FetchSubscriptionInfoCubit>().ifUserSubscription();

  // final isAdmin = user.isAdmin;
  // if (isAdmin) return Future.value(true);
  // if (!user.isLoggedIn) return Future.value(false);
  // final state = context.read<FetchSubscriptionInfoCubit>().state;
  // return Future.value(state is FetchSubscriptionInfoSucceeded);
}

import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_coach/Screens/screens.dart';

import '../Modules/auth/auth_module.dart';

Future<bool> requiresLogin(BuildContext context) async {
  final user = context.read<FetchDataCubit>().state.user;
  final isLoggedIn = user.isNotEmpty;
  if (isLoggedIn) return false;

  showDialog(
    context: context,
    builder: (_) => LoginNeededDialog(onLoginPressed: () {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(builder: (_) => LogInScreen()),
      );
    }),
  );
  return true;
}

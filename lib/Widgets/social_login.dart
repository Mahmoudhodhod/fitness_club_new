import 'dart:developer';
import 'dart:io';

import 'package:authentication/authentication.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Helpers/logger.dart';
import 'package:the_coach/Screens/screens.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

class SocialAuthPreview extends StatelessWidget {
  const SocialAuthPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialLogInCubit(context.read<AuthRepository>()),
      child: const _SocialAuthView(),
    );
  }
}

class _SocialAuthView extends StatefulWidget {
  const _SocialAuthView({Key? key}) : super(key: key);

  @override
  State<_SocialAuthView> createState() => _SocialAuthViewState();
}

class _SocialAuthViewState extends State<_SocialAuthView> {
  Future<bool>? _isAppleSignInAvailable;

  @override
  void initState() {
    _isAppleSignInAvailable =
        context.read<SocialLogInCubit>().isAppleSignInAvailable();
    context.read<AuthRepository>().deleteUserData();
    super.initState();
  }

  void _navigateOnSuccess(BuildContext context, User user) async {
    initCustomerPurchases();

    final model = ModalRoute.of(context);
    final canPop = model?.canPop ?? false;
    if (canPop) {
      Navigator.pop(context);
      Navigator.pop(context);
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      FadePageRoute(builder: (_) => Root()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const border = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)));
    final cubit = context.read<SocialLogInCubit>();
    return BlocListener<SocialLogInCubit, LoginState>(
      listener: (context, state) async {
        LoadingDialog.pop(context);
        if (state is LoginFailed) {
          final err = state.e;
          if (isSocialLoginFailure(err)) {
            final msg = LocaleKeys.error_error_happened.tr() +
                "\n" * 2 +
                err.toString();
            return CSnackBar.failure(messageText: msg).showWithoutContext();
          }
          if (err is SignInWithAppleNotSupported) {
            return CSnackBar.failure(
                    messageText: LocaleKeys.error_apple_not_available.tr())
                .showWithoutContext();
          }
          logger.e("Error during social login", err);
          CSnackBar.failure(messageText: LocaleKeys.error_error_happened.tr())
              .showWithoutContext();
        } else if (state is LoginSuccess) {
          log('state.user ${state.user.toJson()}');
          _navigateOnSuccess(context, state.user);
        } else if (state is LoginInProgress) {
          await LoadingDialog.view(context);
        }
      },
      child: Column(
        children: [
          SignInButton(
            Buttons.Google,
            onPressed: cubit.loginWithGoogle,
            text: LocaleKeys.auth_social_sing_in_with_google.tr(),
            shape: border,
          ),
          // if (Platform.isAndroid)
          // SignInButton(
          //   Buttons.FacebookNew,
          //   onPressed: cubit.loginWithFacebook,
          //   text: LocaleKeys.auth_social_sing_in_with_facebook.tr(),
          //   shape: border,
          // ),
          if (Platform.isIOS) ...[
            const Space.v5(),
            FutureBuilder<bool>(
              future: _isAppleSignInAvailable,
              initialData: false,
              builder: (context, snapshot) {
                final isAvailable = snapshot.data ?? false;
                if (!isAvailable) return const SizedBox.shrink();
                return SizedBox(
                  width: 220,
                  child: SignInWithAppleButton(
                    onPressed: cubit.loginWithApple,
                    style: CColors.switchableObject(
                      dark: SignInWithAppleButtonStyle.white,
                      light: SignInWithAppleButtonStyle.black,
                    )!,
                    height: 35,
                    text: LocaleKeys.auth_social_sing_in_with_apple.tr(),
                  ),
                );
              },
            ),
          ],
          if (kDebugMode) ...[
            const Space.v10(),
            FloatingActionButton(
              child: Icon(Icons.logout_rounded),
              onPressed: () async {
                await context.read<AuthRepository>().deleteUserData();
                appLogger.d("All user's data was deleted");
              },
            ),
          ]
        ],
      ),
    );
  }
}

import 'package:authentication/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import 'set_new.dart';

class PasswordVerificationScreen extends StatelessWidget {
  final String? email;
  const PasswordVerificationScreen({
    Key? key,
    this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authRepo = context.read<AuthRepository>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ForgetPasswordVerfCubit(_authRepo)),
        //[ForgetPasswordCubit] has been used again here and the previous screen [ForgetPasswordScreen]
        //The [ForgetPasswordScreen] cubit instance won't be passed to the current screen and we need
        //the [ForgetPasswordCubit] functionality to resend the code to user's email address.
        BlocProvider(create: (context) => ForgetPasswordCubit(_authRepo)),
      ],
      child: _PasswordVerificationView(email: email),
    );
  }
}

class _PasswordVerificationView extends StatefulWidget {
  final String? email;
  const _PasswordVerificationView({
    Key? key,
    this.email,
  }) : super(key: key);

  @override
  State<_PasswordVerificationView> createState() =>
      _PasswordVerificationViewState();
}

class _PasswordVerificationViewState extends State<_PasswordVerificationView> {
  late final GlobalKey<PinCodeHolderState> _picCodeState;
  @override
  void initState() {
    _picCodeState = GlobalKey();
    super.initState();
  }

  void _resendCode() async {
    context.read<ForgetPasswordCubit>().forgetPassword(widget.email!);
  }

  void _navigateOnSuccess() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SetNewPasswordScreen(),
      ),
    );
  }

  void _verifyCode() {
    final code = _picCodeState.currentState!.validateAndGetCode();
    if (code == null) return;
    context
        .read<ForgetPasswordVerfCubit>()
        .forgetPasswordVerification(widget.email!, code);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state.state == ForgetPasswordS.failed) {
          logError(state.companion);
          CSnackBar.failure(messageText: LocaleKeys.error_error_happened.tr())
              .showWithoutContext();
        } else if (state.state == ForgetPasswordS.loaded) {
          CSnackBar.success(messageText: "Code was resent")
              .showWithoutContext();
        }
      },
      child: KeyboardDismissed(
        child: Scaffold(
          appBar: CAppBar(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _buildContinueButton(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.envelope,
                      size: screenSize.width * 0.4,
                      color: CColors.secondary(context),
                    ),
                    Text(
                      LocaleKeys.auth_general_code_verification_check_your_email
                          .tr(namedArgs: {
                        "email": widget.email ?? '-',
                      }),
                      style: theme(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    Space.v10(),
                    PinCodeHolder(
                      key: _picCodeState,
                      onResendCode: _resendCode,
                      onCompleted: (code) {
                        if (code != null) _verifyCode();
                      },
                    ),
                    Space.v20(),
                    Text(
                      LocaleKeys.auth_general_code_verification_spam_wranging
                          .tr(),
                      style: theme(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return BlocConsumer<ForgetPasswordVerfCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state.state == ForgetPasswordS.failed) {
          logError(state.companion);
          CSnackBar.failure(messageText: LocaleKeys.error_error_happened.tr())
              .showWithoutContext();
        } else if (state.state == ForgetPasswordS.loaded) {
          _navigateOnSuccess();
        }
      },
      builder: (context, state) {
        return CustomButton(
          onPressed: _verifyCode,
          isLoading: state.state == ForgetPasswordS.loading,
          child: Text(LocaleKeys.general_titles_continue).tr(),
        );
      },
    );
  }
}

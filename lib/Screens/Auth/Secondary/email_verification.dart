import 'package:authentication/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_coach/Helpers/logger.dart';
import 'package:the_coach/Helpers/theme_notifier.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Screens/screens.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';
import 'package:the_coach/appsflyer_global.dart';

typedef SuccessCallback = void Function(BuildContext context);

class EmailVerificationScreen extends StatelessWidget {
  final User? user;
  final String? email;

  ///Displays an verification alert dialog, to inform the user that his token
  ///became invalid and he needs to verify his email to continue.
  final bool showValidationAlertDialog;

  ///You must prevent retuning back to this page.
  ///
  final SuccessCallback? onSuccess;

  const EmailVerificationScreen({
    Key? key,
    this.user,
    this.email,
    this.onSuccess,
    this.showValidationAlertDialog = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EmailVerificationCubit(context.read<AuthRepository>()),
      child: _EmailVerificationView(
        user: user,
        email: email,
        onSuccess: onSuccess,
        showValidationAlertDialog: showValidationAlertDialog,
      ),
    );
  }
}

class _EmailVerificationView extends StatefulWidget {
  final User? user;
  final String? email;
  final bool showValidationAlertDialog;

  final SuccessCallback? onSuccess;

  const _EmailVerificationView({
    Key? key,
    this.user,
    this.email,
    this.onSuccess,
    this.showValidationAlertDialog = false,
  }) : super(key: key);

  @override
  _EmailVerificationViewState createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<_EmailVerificationView> {
  late final GlobalKey<PinCodeHolderState> _picCodeState;
  @override
  void initState() {
    _picCodeState = GlobalKey();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.showValidationAlertDialog) {
        showDialog(
            context: context, builder: (_) => const _VerificationDialog());
      }
    });
    super.initState();
  }

  void _confirmEmail() {
    final code = _picCodeState.currentState!.validateAndGetCode();
    if (code == null) return;
    context.read<EmailVerificationCubit>().verifyEmail(code);
  }

  void _navigateOnSuccess() async {
    await appsFlyerGlobal
        .logEvent('af_complete_registration', {...widget.user!.toJson()});
    initCustomerPurchases();
    if (widget.onSuccess != null) {
      return widget.onSuccess!.call(context);
    }
    Navigator.pushAndRemoveUntil(
      context,
      FadePageRoute(builder: (_) => Root()),
      (route) => false,
    );
  }

  void _resendCode() async {
    try {
      await context.read<EmailVerificationCubit>().resendCode();
      CSnackBar.success(messageText: LocaleKeys.success_code_resent.tr())
          .showWithoutContext();
    } catch (e, stacktrace) {
      CSnackBar.failure(
        messageText: LocaleKeys.error_error_happened_because.tr(
          namedArgs: {'cause': e.toString()},
        ),
      ).showWithoutContext();
      appLogger.e("Error while sending code", e, stacktrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmailVerificationCubit, EmailVerificationState>(
      listener: (context, state) {
        if (state.state == EVState.failed) {
          appLogger.e(errorLogStr(state.companion), state.companion);
          final exp = state.companion;
          if (exp is AppException && exp.msg == 'invalid_code') {
            _picCodeState.currentState!.clear();
            CSnackBar.failure(messageText: LocaleKeys.error_wrong_code.tr())
                .showWithoutContext();
            return;
          }
          CSnackBar.failure(messageText: LocaleKeys.error_error_happened.tr())
              .showWithoutContext();
        } else if (state.state == EVState.loaded) {
          _navigateOnSuccess();
        }
      },
      child: KeyboardDismissed(
        child: Scaffold(
          appBar: CAppBar(
              header:
                  LocaleKeys.auth_general_code_verification_verify_email.tr()),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton:
              BlocBuilder<EmailVerificationCubit, EmailVerificationState>(
            builder: (context, state) {
              return CustomButton(
                // onPressed: _confirmEmail,
                onPressed: () {
                  context.read<ThemeNotifier>().switchTheme(ThemeMode.light);
                  setState(() {});
                },
                visualDensity: VisualDensity.comfortable,
                isLoading: state.state == EVState.loading,
                child: Text(LocaleKeys.general_titles_continue).tr(),
              );
            },
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.envelope,
                      size: screenSize.width * 0.4,
                      color: CColors.secondary(context)),
                  Text(
                    LocaleKeys.auth_general_code_verification_check_email.tr(),
                    style: theme(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const Space.v10(),
                  PinCodeHolder(
                    key: _picCodeState,
                    onResendCode: _resendCode,
                    onCompleted: (code) {
                      if (code != null) {
                        context
                            .read<EmailVerificationCubit>()
                            .verifyEmail(code);
                      }
                    },
                  ),
                  const Space.v20(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      LocaleKeys.auth_general_code_verification_spam_wranging
                          .tr(),
                      style: theme(context).textTheme.bodySmall?.copyWith(
                            color: CColors.nullableSwitchable(
                              context,
                              light: Colors.black,
                            ),
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VerificationDialog extends StatelessWidget {
  const _VerificationDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      title: Text(LocaleKeys.error_verification_not_verified_title).tr(),
      content: Text(LocaleKeys.error_verification_not_verified).tr(),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(LocaleKeys.general_titles_ok.tr()),
        ),
      ],
    );
  }
}

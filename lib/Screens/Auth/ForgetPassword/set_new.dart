import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Screens/Auth/Secondary/email_verification.dart';
import 'package:the_coach/Screens/screens.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

class SetNewPasswordScreen extends StatelessWidget {
  const SetNewPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authRepo = context.read<AuthRepository>();
    return BlocProvider(
      create: (context) => SetNewPasswordCubit(_authRepo),
      child: _SetNewPasswordView(),
    );
  }
}

class _SetNewPasswordView extends StatefulWidget {
  const _SetNewPasswordView({Key? key}) : super(key: key);

  @override
  State<_SetNewPasswordView> createState() => _SetNewPasswordViewState();
}

class _SetNewPasswordViewState extends State<_SetNewPasswordView> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _passwordTextController;

  @override
  void initState() {
    _passwordTextController = TextEditingController();
    _formKey = GlobalKey();
    super.initState();
  }

  @override
  void dispose() {
    _passwordTextController.dispose();
    super.dispose();
  }

  void _confirmNewPassword() {
    if (!_formKey.currentState!.validate()) return;
    final password = _passwordTextController.text.trim();
    if (password.isEmpty) {
      CSnackBar.failure(messageText: 'PASSWORD IS EMPTY').showWithoutContext();
      return;
    }
    context.read<SetNewPasswordCubit>().setNewPassword(password, password);
  }

  void _navigateBackToLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      FadePageRoute(builder: (_) => LogInScreen()),
      (route) => false,
    );
  }

  void _navigateToEmailVerification(User user) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => EmailVerificationScreen(
          user: user,
          onSuccess: _navigateBackToLogin,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissed(
      child: Scaffold(
        appBar: CAppBar(header: LocaleKeys.auth_password_recovery_reset_passwrod.tr()),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _buildContinueButton(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Icon(
                        FontAwesomeIcons.retweet,
                        size: screenSize.width * 0.25,
                        color: CColors.secondary(context),
                      ),
                      Space.v20(),
                      CTextField(
                        controller: _passwordTextController,
                        keyboardType: TextInputType.visiblePassword,
                        title: LocaleKeys.auth_password_recovery_new_password.tr(),
                        validator: (value) {
                          if (isLengthLessThan(value, 6)) {
                            return LocaleKeys.auth_general_validation_invalid_password.tr();
                          }
                          return null;
                        },
                      ),
                      CTextField(
                        keyboardType: TextInputType.visiblePassword,
                        title: LocaleKeys.auth_password_recovery_new_password_confirmation.tr(),
                        validator: (value) {
                          final _password = _passwordTextController.text.trim();
                          if (_password != value!) {
                            return LocaleKeys.auth_general_validation_password_not_match.tr();
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return BlocConsumer<SetNewPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state.state == ForgetPasswordS.failed) {
          logError(state.companion);
          CSnackBar.failure(messageText: LocaleKeys.error_error_happened.tr()).showWithoutContext();
        } else if (state.state == ForgetPasswordS.loaded) {
          if (!state.isVerified) {
            CSnackBar.failure(messageText: LocaleKeys.error_verification_user_not_verified.tr()).showWithoutContext();
            return _navigateToEmailVerification(state.user!);
          }
          CSnackBar.success(messageText: LocaleKeys.success_password_changed_successfuly.tr()).showWithoutContext();
          _navigateBackToLogin(context);
        }
      },
      builder: (context, state) {
        return CustomButton(
          onPressed: _confirmNewPassword,
          isLoading: state.state == ForgetPasswordS.loading,
          child: Text(LocaleKeys.general_titles_confirm).tr(),
        );
      },
    );
  }
}

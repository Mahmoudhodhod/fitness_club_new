import 'package:authentication/authentication.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/utils.dart' hide Trans;
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import 'verification.dart';

class ForgetPasswordScreen extends StatelessWidget {
  final String? email;
  const ForgetPasswordScreen({
    Key? key,
    this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authRepo = context.read<AuthRepository>();
    return BlocProvider(
      create: (context) => ForgetPasswordCubit(_authRepo),
      child: _ForgetPasswordView(email: email),
    );
  }
}

class _ForgetPasswordView extends StatefulWidget {
  final String? email;
  const _ForgetPasswordView({Key? key, this.email}) : super(key: key);

  @override
  State<_ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<_ForgetPasswordView> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _emailTextController;

  @override
  void initState() {
    _emailTextController = TextEditingController(text: widget.email);
    _formKey = GlobalKey();
    super.initState();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    super.dispose();
  }

  void _navigateToVerification() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PasswordVerificationScreen(
          email: _emailTextController.text.trim(),
        ),
      ),
    );
  }

  void _sendCode() {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailTextController.text.trim();
    context.read<ForgetPasswordCubit>().forgetPassword(email);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissed(
      child: Scaffold(
        appBar: CAppBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _buildContinueButton(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Icon(
                      CupertinoIcons.envelope,
                      size: screenSize.width * 0.4,
                      color: CColors.secondary(context),
                    ),
                    Text(
                      LocaleKeys.auth_password_recovery_enter_email.tr(),
                      style: theme(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    Space.v20(),
                    Form(
                      key: _formKey,
                      child: CTextField(
                        controller: _emailTextController,
                        hint: 'example@mail.com',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null ||
                              !EmailValidator.validate(value)) {
                            return LocaleKeys
                                .auth_general_validation_invalid_email
                                .tr();
                          }
                          return null;
                        },
                      ),
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
    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state.state == ForgetPasswordS.failed) {
          logError(state.companion);
          CSnackBar.failure(messageText: LocaleKeys.error_error_happened.tr())
              .showWithoutContext();
        } else if (state.state == ForgetPasswordS.loaded) {
          _navigateToVerification();
        }
      },
      builder: (context, state) {
        return CustomButton(
          onPressed: _sendCode,
          isLoading: state.state == ForgetPasswordS.loading,
          child: Text(LocaleKeys.general_titles_continue).tr(),
        );
      },
    );
  }
}

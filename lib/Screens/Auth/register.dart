import 'dart:io';

import 'package:authentication/authentication.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Helpers/logger.dart';
import 'package:the_coach/Helpers/network.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import 'Secondary/email_verification.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return KeyboardDismissed(
      child: Scaffold(
        appBar: CAppBar(
          header: LocaleKeys.auth_registation_title.tr(),
        ),
        body: BlocProvider(
          create: (context) => RegisterCubit(context.read<AuthRepository>()),
          child: SafeArea(
            child: const _RegisterForm(),
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nameTextController;
  late final TextEditingController _passwordController;
  late final TextEditingController _emailController;
  Gender _userGender = Gender.male;
  File? _userImage;
  bool _acceptTermsOfService = false;

  @override
  void initState() {
    _formKey = GlobalKey();
    _nameTextController = TextEditingController();
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _pickUserImage() async {
    try {
      final _images =
          await MediaController.instance.openSheetAndPickImage(context);
      if (_images == null) return;
      setState(() {
        _userImage = _images.first;
      });
    } catch (e, stacktrace) {
      appLogger.e("Error while picking user image", e, stacktrace);
    }
  }

  void _navigateOnSuccessToVerification(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmailVerificationScreen(user: user),
      ),
    );
  }

  void _performRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (_userImage == null) {
      CSnackBar.failure(
        messageText: LocaleKeys.error_validation_required_image.tr(),
      ).showWithoutContext();
      return;
    }
    AuthUser user = AuthUser(
      email: _emailController.text.trim(),
      name: _nameTextController.text.trim(),
      password: _passwordController.text.trim(),
      passwordConfirmation: _passwordController.text.trim(),
      gender: _userGender,
      image: _userImage,
    );
    context.read<RegisterCubit>().registerFormSubmitted(user);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterFailed) {
          CSnackBar.failure(
            messageText: LocaleKeys.error_error_happened.tr(),
          ).showWithoutContext();
          logError(state.e);
        } else if (state is RegisterSuccess) {
          _navigateOnSuccessToVerification(state.user);
        }
      },
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30, top: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialAuthPreview(),
                const Divider(endIndent: 20, indent: 20),
                GestureDetector(
                  onTap: _pickUserImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: CColors.switchable(
                      context,
                      dark: CColors.fancyBlack,
                      light: Colors.grey.shade200,
                    ),
                    backgroundImage:
                        _userImage != null ? FileImage(_userImage!) : null,
                    child: _userImage != null
                        ? null
                        : Icon(Icons.person, size: 40),
                  ),
                ),
                Space.v10(),
                _buildRegistrationFields(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegistrationFields() {
    return Center(
      child: Padding(
        padding: KEdgeInsets.h10,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: KBorders.bc5),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 3.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CTextField(
                  isRequired: true,
                  controller: _nameTextController,
                  title: LocaleKeys.auth_general_name.tr(),
                ),
                Space.v5(),
                CTextField(
                  isRequired: true,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  title: LocaleKeys.auth_general_email.tr(),
                  validator: (value) {
                    if (value == null || !EmailValidator.validate(value)) {
                      return LocaleKeys.auth_general_validation_invalid_email
                          .tr();
                    }
                    return null;
                  },
                ),
                Space.v5(),
                CTextField(
                  isRequired: true,
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  title: LocaleKeys.auth_general_password.tr(),
                  validator: (value) {
                    if (isLengthLessThan(value, 6)) {
                      return LocaleKeys.auth_general_validation_invalid_password
                          .tr();
                    }
                    return null;
                  },
                ),
                Space.v5(),
                CTextField(
                  isRequired: true,
                  keyboardType: TextInputType.visiblePassword,
                  title: LocaleKeys.auth_general_password_confirmation.tr(),
                  validator: (value) {
                    final _password = _passwordController.text.trim();
                    if (_password != value!) {
                      return LocaleKeys
                          .auth_general_validation_password_not_match
                          .tr();
                    }
                    return null;
                  },
                ),
                if (!Platform.isIOS) ...[
                  GenderPicker(onChanged: (gender) => _userGender = gender),
                ],
                Space.v5(),
                _buildTermsAndConditionsCheckBox(),
                Space.v10(),
                _RegisterSubmitButton(
                  acceptTermsOfService: _acceptTermsOfService,
                  onPressed: _performRegister,
                ),
                Space.v10(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: Size.zero,
                  ),
                  child: Text(
                    LocaleKeys.auth_registation_have_an_account.tr(),
                    style: theme(context).textTheme.bodySmall?.copyWith(
                          color: CColors.primary(context),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _acceptTerms() {
    if (mounted) setState(() => _acceptTermsOfService = !_acceptTermsOfService);
  }

  Widget _buildTermsAndConditionsCheckBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          SizedBox.fromSize(
            size: Size.square(30),
            child: Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(borderRadius: KBorders.bc20),
              value: _acceptTermsOfService,
              onChanged: (_) => _acceptTerms(),
            ),
          ),
          const Space.h10(),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: LocaleKeys.auth_terms_accept.tr(),
                recognizer: TapGestureRecognizer()..onTap = _acceptTerms,
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = launchTermsOfService,
                    text: LocaleKeys.drawer_settings_terms_of_service.tr(),
                    style: TextStyle(
                        color: CColors.primary(context),
                        decoration: TextDecoration.underline),
                  ),
                  TextSpan(text: '  '),
                  TextSpan(text: LocaleKeys.auth_terms_and.tr()),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = launchPrivacyPolicy,
                    text: LocaleKeys.drawer_settings_privacy_policy.tr(),
                    style: TextStyle(
                        color: CColors.primary(context),
                        decoration: TextDecoration.underline),
                  ),
                ],
              ),
              style:
                  theme(context).textTheme.titleSmall?.copyWith(fontSize: 15.0),
            ),
          )
        ],
      ),
    );
  }
}

class _RegisterSubmitButton extends StatelessWidget {
  final bool acceptTermsOfService;
  final VoidCallback onPressed;
  const _RegisterSubmitButton({
    Key? key,
    required this.acceptTermsOfService,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return CustomButton(
          enabled: acceptTermsOfService,
          isLoading: state is RegisterInProgress,
          onPressed: onPressed,
          child: Text(LocaleKeys.auth_registation_title.tr()),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        );
      },
    );
  }
}

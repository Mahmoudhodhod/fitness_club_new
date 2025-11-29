import 'dart:developer';

import 'package:authentication/authentication.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Helpers/localization_utilities.dart';
import 'package:the_coach/Helpers/theme_notifier.dart';
import 'package:the_coach/Screens/Helpers/fade_page_route.dart';
import 'package:the_coach/Screens/root.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import 'ForgetPassword/forget_password.dart';
import 'Secondary/email_verification.dart';
import 'register.dart';

class LogInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(context.read()),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _passwordController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    _formKey = GlobalKey();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    if (kDebugMode) {
      final role = UserRole.client;
      if (role == UserRole.admin) {
        _emailController.text = "super_admin@admin.com";
        _passwordController.text = "super_admin@admin.com";
      } else {
        _emailController.text = "ahmed@mail.com";
        _passwordController.text = "password";
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onLoginSuccess(User user) async {
    log('useruser ${user.toJson()}');

    initCustomerPurchases();

    final model = ModalRoute.of(context);
    final canPop = model?.canPop ?? false;
    if (canPop) {
      Navigator.pop(context);
      return;
    }
    Navigator.pushAndRemoveUntil(
      context,
      FadePageRoute(builder: (_) => Root()),
      (route) => false,
    );
  }

  void _navigateOnSuccessToVerification(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmailVerificationScreen(user: user),
      ),
    );
  }

  void _navigateToForgetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Builder(
            builder: (_) => ForgetPasswordScreen(email: _emailController.text)),
      ),
    );
  }

  void _clearTextControllers() {
    _passwordController.clear();
  }

  void _performRegister() async {
    if (!_formKey.currentState!.validate()) return;
    AuthUser user = AuthUser(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    context.read<LoginCubit>().loginFormSubmitted(user);
  }

  @override
  Widget build(BuildContext context) {
    final _cardPadding = EdgeInsets.fromLTRB(15, 20, 15, 3.0);
    var isDarkMode = context.watch<ThemeNotifier>().isDarkMode;
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginFailed) {
          logError(state.e);
          _clearTextControllers();
          CSnackBar.failure(
            messageText: LocaleKeys.error_login_error.tr(),
          ).showWithoutContext();
        } else if (state is LoginSuccess) {
          if (!state.isVerified) {
            return _navigateOnSuccessToVerification(state.user);
          } else {
            _onLoginSuccess(state.user);
          }
        } else if (state is LoginFailedWithUnauthorizedUser) {
          /* do nothing  */
        }
      },
      child: KeyboardDismissed(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: isDarkMode
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                LocaleKeys.auth_login_title.tr(),
                style: theme(context).textTheme.headlineSmall,
              ),
            ),
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: KEdgeInsets.h15,
                  child: Column(
                    children: [
                      _buildBody(_cardPadding),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => RegisterScreen()));
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: Size.zero,
                        ),
                        child: Text(
                          LocaleKeys.auth_login_have_no_account.tr(),
                          style: theme(context).textTheme.bodySmall?.copyWith(
                                color: CColors.primary(context),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      Divider(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // TextButton(
                          //   onPressed: () {
                          //     final model = ModalRoute.of(context);
                          //     final canPop = model?.canPop ?? false;
                          //     if (canPop) {
                          //       Navigator.pop(context);
                          //       return;
                          //     }
                          //     Navigator.pushAndRemoveUntil(
                          //       context,
                          //       FadePageRoute(builder: (_) => Root()),
                          //       (route) => false,
                          //     );
                          //   },
                          //   child: Text(LocaleKeys.auth_guest_user_skip.tr()),
                          // ),
                          const _LangSwitch(),
                          const Space.v30(),
                          Text(
                            '${AppPackageInfo.instance().appVersion()}',
                            style: theme(context).textTheme.bodySmall?.copyWith(
                                  color: CColors.secondary(context),
                                ),
                          ),
                        ],
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

  Widget _buildBody(EdgeInsets _cardPadding) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: KBorders.bc10),
      shadowColor: Colors.black45,
      elevation: 5,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: _cardPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SocialAuthPreview(),
                  const Divider(height: 40, color: Colors.white24),
                  CTextField(
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
                  CTextField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    title: LocaleKeys.auth_general_password.tr(),
                    validator: (value) {
                      if (isLengthLessThan(value, 6)) {
                        return LocaleKeys
                            .auth_general_validation_invalid_password
                            .tr();
                      }
                      return null;
                    },
                  ),
                  _LoginSubmitButton(onPressed: _performRegister),
                ],
              ),
            ),
            const Space.v5(),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: CColors.nullableSwitchable(context,
                    dark: CColors.lightBlack),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(10)),
              ),
              child: Center(
                child: Column(
                  children: [
                    InkWell(
                      onTap: _navigateToForgetPassword,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 10),
                        child: Text(
                          LocaleKeys.auth_login_forget_password.tr(),
                          style: theme(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: CColors.primary(context)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _LoginSubmitButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return CustomButton(
          isLoading: state is LoginInProgress,
          onPressed: onPressed,
          child: Text(
            LocaleKeys.auth_login_title.tr(),
            style: theme(context).textTheme.titleMedium!.copyWith(
                  color: CColors.switchable(
                    context,
                    dark: CColors.darkerBlack,
                    light: Colors.white,
                  ),
                  fontWeight: FontWeight.bold,
                ),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        );
      },
    );
  }
}

class _LangSwitch extends StatefulWidget {
  const _LangSwitch({Key? key}) : super(key: key);

  @override
  State<_LangSwitch> createState() => _LangSwitchState();
}

class _LangSwitchState extends State<_LangSwitch> {
  void _switch(Locale locale) {
    context.changeLang(locale);
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          key: Key("arabic_language"),
          onPressed: currentLocale == Locale('ar')
              ? null
              : () => _switch(Locale('ar')),
          child: Text(
            "العربية",
            style: TextStyle(
              color: CColors.switchable(
                context,
                dark: Colors.grey.shade200,
                light: CColors.darkerBlack,
              ),
            ),
          ),
        ),
        TextButton(
          key: Key("english_language"),
          onPressed: currentLocale == Locale('en')
              ? null
              : () => _switch(Locale('en')),
          child: Text("English",
              style: TextStyle(
                color: CColors.switchable(
                  context,
                  dark: CColors.primary(context),
                  light: CColors.secondary(context),
                ),
              )),
        ),
      ],
    );
  }
}

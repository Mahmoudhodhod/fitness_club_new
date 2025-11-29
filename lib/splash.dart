import 'package:app_security/app_security.dart';
import 'package:authentication/authentication.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart' show IAPController;
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Helpers/constants.dart';
import 'package:the_coach/Helpers/logger.dart';
import 'package:the_coach/Modules/Settings/settings.dart';
import 'package:the_coach/Screens/screens.dart';

import 'Screens/Auth/Secondary/email_verification.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColors.splashBackground,
      body: SafeArea(
        child: const _SplashView(),
      ),
    );
  }
}

class _SplashView extends StatefulWidget {
  const _SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitializationData();
      _setupInterceptor();
    });
    super.initState();
  }

  Future<void> _fetchInitializationData() async {
    // try {
    //   await checkDeviceSecurity();
    // } on SecurityResultException catch (result) {
    //   await NotRealDeviceDialog(code: result.code ?? -1).show(context);
    //   return;
    // }

    context.read<FetchDataCubit>().fetchCurrentUserData();
    IAPController.get(context).initPurchases(debugMode: true);
    context.read<FetchAppSettingsCubit>().fetchAppSettings();
  }

  void _setUpCrashlytics(String id) {
    FirebaseCrashlytics.instance.setUserIdentifier(id);
  }

  Future<void> _fadeNavigation(Widget to) {
    return Navigator.pushAndRemoveUntil(
      context,
      FadePageRoute(builder: (_) => to),
      (route) => false,
    );
  }

  void _setupInterceptor() {
    final _context = NavigationService.context!;
    final _dio = _context.read<Dio>();
    _dio.interceptors.add(registerUserEmailVerificationNetworkInterceptor(
      tokenExpired: () async =>
          _context.read<AuthRepository>().isTokenExpired(),
      onTokenExpired: () async {
        appLogger.d("TOKEN HAS EXPIRED");
        await Future.delayed(Duration.zero);
        Navigator.push(
          _context,
          MaterialPageRoute(
            builder: (_) => EmailVerificationScreen(),
          ),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FetchDataCubit, FetchDataState>(
      listener: (context, state) async {
        final loadingState = state.loadingState;
        if (loadingState == LoadingState.loaded) {
          final user = state.user;
          // initCustomerPurchases();
          _setUpCrashlytics(user.uuid);

          _fadeNavigation(Root());
        } else if (loadingState == LoadingState.failed) {
          _fadeNavigation(LogInScreen());
        }
      },
      builder: (context, state) {
        return Center(
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(kAppIntro2PNG, fit: BoxFit.cover),
              ),
              Align(
                alignment: const Alignment(0, .9),
                child: Visibility(
                  replacement: SizedBox.fromSize(size: const Size.square(40)),
                  child: SizedBox.fromSize(
                    size: const Size.square(40),
                    child:
                        const CircularProgressIndicator(color: Colors.white60),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

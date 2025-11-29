import 'package:authentication/authentication.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:preferences_utilities/preferences_utilities.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/app_rating.dart';
import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Helpers/in_app_update.dart';
import 'package:the_coach/Helpers/logger.dart';
import 'package:the_coach/Helpers/showcase_controller.dart';
import 'package:the_coach/Modules/Chat/Cubits/cubits.dart';
import 'package:the_coach/Modules/DeepLinking/deep_linking_module.dart';
import 'package:the_coach/Modules/Muscles/muscles_module.dart';
import 'package:the_coach/Modules/Payment/payment.dart';
import 'package:the_coach/Modules/PushNotifications/service.dart';
import 'package:the_coach/Screens/screens.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import '../Helpers/constants.dart';
import '../Modules/PushNotifications/push_notification_handler.dart'
    as NotificationHandler;
import 'Tabs/MainExercises/main_exercises_categories.dart';

Future<void> initCustomerPurchases() async {
  final context = NavigationService.context;
  assert(context != null, '[initCustomerPurchases] Context is null');
  final user = await context!.read<AuthRepository>().fetchUserData();
  if (user.isEmpty) return;
  final s = Subscriber(
    id: user.id,
    uuid: user.uuid,
    name: user.name,
    email: user.email,
    registeredAt: user.registeredAt!,
    imagePath: user.profileImagePath,
    isAdmin: user.isAdmin,
  );
  await IAPController.get(context).login(s);
  // IAPController.get(context).getSubscriber(() async => s);
  // final x = context.read<FetchSubscriptionInfoCubit>().fetchSubscriptionInfo();
  // appLogger.d('x.toString() ${x.toString()}');
}

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  late final PersistentTabController _controller;

  BuildContext? showCaseContext;
  final articlesK = GlobalKey();
  final plansK = GlobalKey();
  final musclesK = GlobalKey();
  final powerTrainingK = GlobalKey();
  final utilitiesK = GlobalKey();

  @override
  void initState() {
    // if (kDebugMode) {
    //   ShowcaseController().resetShowcase("__NAV_BAR_SHOWCASE__");
    //   ShowcaseController().resetShowcase("__DRAWER_SHOWCASE__");
    // }

    _controller = PersistentTabController(initialIndex: 1);
    context.read<FetchMusclesCubit>().fetchMuscles();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initApp();
    });
    super.initState();
  }

  Future<void> _initApp() async {
    PushNotificationService.initialize();
    _initFCM();
    _initChatData();
    _initInAppPurchases();
    final currentUser = context.read<FetchDataCubit>().state.user;
    // Show app rating dialog if user is registered for more than 7 days
    if (currentUser.registeredAt != null &&
        currentUser.registeredAt!
            .isAfter(DateTime.now().subtract(const Duration(days: 7)))) {
      displayAppRating();
    }
    Future.delayed(Duration(seconds: 2), () {
      checkNewVersionUpdate();
    });
  }

  void _initInAppPurchases() async {
    final user = await context.read<AuthRepository>().fetchUserData();
    final registeredAt =
        user.registeredAt ?? DateTime.now().subtract(const Duration(days: 10));
    IAPController.get(context).getSubscriber(() async {
      return Subscriber(
        id: user.id,
        uuid: user.uuid,
        name: user.email,
        email: user.email,
        registeredAt: registeredAt,
        // registeredAt: DateTime.now().add(Duration(days: -1)),
        imagePath: user.profileImagePath,
        isAdmin: user.isAdmin,
      );
    });
    await context
        .read<FetchSubscriptionStatusCubit>()
        .fetchSubscriptionStatus();
  }

  void _startOnboarding() {
    if (showCaseContext == null) return;
    ShowcaseController().shouldDisplay("__NAV_BAR_SHOWCASE__", () {
      ShowCaseWidget.of(showCaseContext!).startShowCase([
        articlesK,
        plansK,
        musclesK,
        powerTrainingK,
        utilitiesK,
      ]);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const _screens = <Widget>[
      ArticleHomeScreen(),
      PlansMainScreen(),
      AllMusclesScreen(),
      MainExercisesCategoriesScreen(),
      UtilitiesScreen(),
    ];
    final _items = <PersistentBottomNavBarItem>[
      _buildTapItem(
          key: articlesK,
          description: LocaleKeys.showcase_bottom_nav_bar_articles.tr(),
          title: LocaleKeys.screens_articles_title.tr(),
          icon: FontAwesomeIcons.mobileAlt),
      _buildTapItem(
          key: plansK,
          description: LocaleKeys.showcase_bottom_nav_bar_plans.tr(),
          title: LocaleKeys.screens_plans_title.tr(),
          iconSize: 17,
          icon: FontAwesomeIcons.dumbbell),
      _buildTapItem(
          key: musclesK,
          description: LocaleKeys.showcase_bottom_nav_bar_muscles.tr(),
          title: LocaleKeys.screens_all_muscles_title.tr(),
          icon: FontAwesomeIcons.running),
      _buildTapItem(
          key: powerTrainingK,
          description: LocaleKeys.showcase_bottom_nav_bar_power_exercises.tr(),
          title: LocaleKeys.screens_power_training_title.tr(),
          icon: FontAwesomeIcons.gavel),
      _buildTapItem(
          key: utilitiesK,
          description: LocaleKeys.showcase_bottom_nav_bar_utilities.tr(),
          title: LocaleKeys.screens_utilities_title.tr(),
          icon: FontAwesomeIcons.tools),
    ];
    final _iapController = IAPController.get(context);

    return BlocProvider(
      create: (context) =>
          DisplaySubscriptionReminderViewCubit(controller: _iapController),
      child: MultiBlocListener(
        listeners: _paymentListeners(),
        child: ShowCaseWidget(builder: (context) {
          showCaseContext = context;
          return PersistentTabView(
            context,
            controller: _controller,
            screens: _screens,
            items: _items,
            confineInSafeArea: true,
            bottomScreenMargin: 40,
            backgroundColor: CColors.switchable(
              context,
              dark: CColors.fancyBlack,
              light: Colors.grey.shade200,
            ),
            handleAndroidBackButtonPress: true,
            resizeToAvoidBottomInset: true,
            stateManagement: true,
            floatingActionButton: Padding(
              padding: const EdgeInsetsDirectional.only(
                bottom: 20,
              ),
              child: CircleAvatar(
                foregroundColor: CColors.switchable(context,
                    dark: CColors.fancyBlack, light: CColors.primary(context)),
                backgroundColor: CColors.switchable(context,
                    dark: CColors.fancyBlack, light: CColors.primary(context)),
                radius: 30,
                child: FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  elevation: 0,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatScreen(),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    chatSVG,
                    width: 32,
                    height: 32,
                    color: CColors.switchable(
                      context,
                      dark: CColors.primary(context),
                      light: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            hideNavigationBarWhenKeyboardShows: true,
            decoration: const NavBarDecoration(
              borderRadius: BorderRadius.zero,
              colorBehindNavBar: Colors.white,
            ),
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            itemAnimationProperties: const ItemAnimationProperties(
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: const ScreenTransitionAnimation(
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
            ),
            navBarStyle: NavBarStyle.style3,
          );
        }),
      ),
    );
  }

  ///Builds nav bar item with [icon] and [title],
  ///
  PersistentBottomNavBarItem _buildTapItem({
    required GlobalKey key,
    required String description,
    required IconData icon,
    required String title,
    double iconSize = 20,
  }) {
    final activeColor = CColors.primary(context);
    final inActiveColor = CColors.switchable(
      context,
      dark: Colors.grey.shade400,
      light: Colors.grey.shade600,
    );
    final isEnglish = context.locale.isEnglish;
    final fontScaleFactor = MediaQuery.of(context).textScaleFactor;
    final fontSize = 9 * fontScaleFactor * (isEnglish ? 1.3 : 1);
    return PersistentBottomNavBarItem(
      title: title,
      iconSize: iconSize,
      showCaseBuilder: (context, child) {
        return Showcase(
          key: key,
          description: description,
          targetBorderRadius: BorderRadius.circular(10),
          child: child,
        );
      },
      icon: Icon(icon),
      textStyle: GoogleFonts.tajawal(
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
      ),
      activeColorPrimary: activeColor,
      activeColorSecondary: activeColor,
      inactiveColorPrimary: inActiveColor,
      inactiveColorSecondary: inActiveColor,
    );
  }

  Future<void> _initFCM() async {
    try {
      await PushNotificationService.requestPermission();
      await PushNotificationService.initialize();
      final token = await PushNotificationService.getToken();
      await PushNotificationService.updateServiceFCM(
          context.read<AuthRepository>());
      await PreferencesUtilities.instance!
          .saveValueWithKey<String>('fcm', token ?? '');
      appLogger.d('FCM TOKEN: $token');
      NotificationHandler.registerNotification();
      NotificationHandler.initLocalNotification(context);
      FirebaseMessaging.onBackgroundMessage(
          NotificationHandler.backgroundHandler);
      FirebaseMessaging.onMessageOpenedApp;
      FirebaseMessaging.onMessage.listen((event) {
        // NotificationCubit.get(context).addNotification();
        if (event.data.isNotEmpty) {
          showNotification(event, "${event.data}", onMessage: true);
        } else {
          showNotification(event, "${event.notification}");
        }
      });
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) {
        if (message != null) {
          if (message.data.isNotEmpty) {
            NotificationHandler.handleNotificationsTap(
                message.data.toString(), context);
          } else {
            NotificationHandler.handleNotificationsTap(
                "${message.notification}", context);
          }
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        // NotificationCubit.get(context).addNotification();
        NotificationHandler.handleNotificationsTap(
          event.data.toString(),
          NavigationService.navigatorKey.currentContext,
        );
      });
    } on PermissionNotGranted {
      /* do nothing */
    } catch (e, stacktrace) {
      appLogger.e("Error while initializing FCM", e, stacktrace);
    }
  }

  void _initChatData() {
    final currentUser = context.read<FetchDataCubit>().state.user;

    context.read<ChatCubit>().init(currentUser);
  }

  List<BlocListener> _paymentListeners() {
    void navigateToFreeTrialEndedScreen() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FreeTrialEnded(),
        ),
      );
    }

    void openFreeTrialDialog(int remainingInSeconds) async {
      final context = NavigationService.context!;
      await showDialog<void>(
        context: context,
        builder: (context) {
          return FreeTrialDialog(
            remainingTimeInSecondes: remainingInSeconds,
            onFreeTrialEnded: () => navigateToFreeTrialEndedScreen(),
          );
        },
      );
      _startOnboarding();
    }

    return [
      BlocListener<DisplaySubscriptionReminderViewCubit,
          DisplaySubscriptionRemiderViewState>(
        listener: (_, state) {
          if (state is DisplayTrialEndView) {
            return navigateToFreeTrialEndedScreen();
          } else if (state is DisplayTrailReminderView) {
            openFreeTrialDialog(state.remainingTimeInSecondes);
          }
        },
      ),
      BlocListener<FetchSubscriptionStatusCubit, FetchSubscriptionStatusState>(
        listener: (context, state) {
          if (state is FetchSubscriptionStatusResultedNeverSubscribed) {
            context.read<DisplaySubscriptionReminderViewCubit>().displayView();
          } else if (state is FetchSubscriptionStatusResultedExpiration) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SubscriptionExpired(),
              ),
            );
          }
          // appLogger.v(state);
        },
      ),
      BlocListener<WatchSubscriberInfoChangeCubit,
          WatchSubscriberInfoChangeState>(
        listener: (context, state) {
          /* do nothing */
        },
      ),
      BlocListener<ProcessDeepLinkingOptionsCubit,
          ProcessDeepLinkingOptionsState>(
        listener: (context, state) async {
          if (state is ProcessDeepLinkingOptionsIsLoading) {
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const DeepLinkingProcessDialog(),
            );
          } else if (state is ProcessDeepLinkingOptionsSucceeded) {
            Navigator.pop(context);
          } else if (state is ProcessDeepLinkingOptionsFailure) {
            Navigator.pop(context);
            CSnackBar.failure(messageText: LocaleKeys.error_error_happened.tr())
                .show(context);
          }
        },
      )
    ];
  }
}

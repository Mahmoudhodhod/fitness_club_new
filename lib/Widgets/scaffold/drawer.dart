import 'dart:developer';

import 'package:authentication/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart' show IAPController;
import 'package:showcaseview/showcaseview.dart';
import 'package:the_coach/Helpers/showcase_controller.dart';
import 'package:the_coach/Modules/Chat/_utilites.dart';
import 'package:utilities/utilities.dart';
import 'package:the_coach/Helpers/app_rating.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Helpers/constants.dart';
import 'package:the_coach/Helpers/logger.dart';
import 'package:the_coach/Modules/Payment/Widgets/vip_visible.dart';
import 'package:the_coach/Modules/Payment/payment.dart';
import 'package:the_coach/Modules/auth/auth_module.dart';
import 'package:the_coach/Screens/General/Settings/settings.dart';
import 'package:the_coach/Screens/General/Subscriptions/my_subscriptions.dart';
import 'package:the_coach/Screens/Tabs/Plans/CustomPlans/custom_plans.dart';
import 'package:the_coach/Screens/screens.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import '../../Helpers/theme_notifier.dart';

class _DrawerListModel {
  final GlobalKey? key;
  final String? description;
  final String title;
  final Widget? icon;
  final VoidCallback? onTap;
  final Widget? trailing;
  const _DrawerListModel({
    this.key,
    this.description,
    required this.title,
    this.icon,
    this.onTap,
    this.trailing,
  });
}

class CDrawer extends StatelessWidget {
  const CDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _CDrawer();
  }
}

class _CDrawer extends StatefulWidget {
  const _CDrawer({Key? key}) : super(key: key);

  @override
  _CDrawerState createState() => _CDrawerState();
}

class _CDrawerState extends State<_CDrawer> {
  BuildContext? showCaseContext;
  final contactCapitanK = GlobalKey();
  final myPlansK = GlobalKey();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 250));
      if (showCaseContext == null) return;
      ShowcaseController().shouldDisplay("__DRAWER_SHOWCASE__", () {
        ShowCaseWidget.of(showCaseContext!).startShowCase([
          myPlansK,
          contactCapitanK,
        ]);
      });
    });
  }

  void _attemptToLogout() {
    showDialog(
      context: context,
      builder: (_) => const LogoutDialog(),
    );
  }

  void _openPaymentLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => LoginPaymentNeededDialog(
        onLoginPressed: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(builder: (_) => LogInScreen()),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<FetchDataCubit>().state.user;

    var isDarkMode = context.watch<ThemeNotifier>().isDarkMode;

    final _items = [
      _DrawerListModel(
        key: myPlansK,
        description: LocaleKeys.showcase_drawer_my_plans.tr(),
        onTap: () {
          if (!currentUser.isLoggedIn) {
            showDialog(
              context: context,
              builder: (context) => LoginNeededDialog(
                onLoginPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (_) => LogInScreen()),
                  );
                },
              ),
            );
            return;
          }
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (_) => CustomPlansScreen(),
            ),
          );
        },
        title: LocaleKeys.screens_plans_custom_plans_title.tr(),
        icon: WorkoutPlansIcon(color: CColors.primary(context)),
      ),
      if (currentUser.isClient) ...[
        _DrawerListModel(
          onTap: () {
            if (!currentUser.isLoggedIn) {
              _openPaymentLoginDialog(context);
              return;
            }
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (_) => MySubscription(),
              ),
            );
          },
          title: LocaleKeys.payment_general_subscriptions.tr(),
          icon: Icon(FontAwesomeIcons.star),
        ),
      ],
      if (currentUser.isAdmin) ...[
        _DrawerListModel(
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (_) => AdminChatScreen(),
              ),
            );
          },
          icon: Icon(CupertinoIcons.chat_bubble_2),
          title: LocaleKeys.drawer_chat_with_users.tr(),
        ),
      ] else if (currentUser.isClient) ...[
        _DrawerListModel(
          key: contactCapitanK,
          description: LocaleKeys.showcase_drawer_contact_capitan.tr(),
          onTap: () {
            if (!currentUser.isLoggedIn) {
              _openPaymentLoginDialog(context);
              return;
            }
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (_) => ChatScreen(),
              ),
            );
          },
          icon: Icon(CupertinoIcons.chat_bubble),
          title: LocaleKeys.drawer_chat_with_coach.tr(),
          trailing: VIPVisible(
            child: Icon(Icons.chevron_right, color: Colors.white54),
            replacement: VIPIcon(),
          ),
        ),
      ],
      _DrawerListModel(
        onTap: openRateListing,
        title: LocaleKeys.app_rating_title.tr(),
        icon: Icon(
          FontAwesomeIcons.starHalfAlt,
        ),
      ),
      _DrawerListModel(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(builder: (_) => SettingsScreen()),
          );
        },
        icon: Icon(Icons.settings),
        title: LocaleKeys.drawer_settings_title.tr(),
      ),
      if (currentUser.isLoggedIn) ...[
        _DrawerListModel(
          onTap: _attemptToLogout,
          icon: Icon(Icons.logout_outlined),
          title: LocaleKeys.auth_logout_title.tr(),
        ),
      ] else ...[
        _DrawerListModel(
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(builder: (_) => LogInScreen()),
            );
          },
          icon: Icon(Icons.login_outlined),
          title: LocaleKeys.auth_login_title.tr(),
        ),
      ]
    ];
    return ShowCaseWidget(
      builder: (context) {
        showCaseContext = context;
        return Drawer(
          child: Container(
            color: isDarkMode ? CColors.fancyBlack : Colors.white,
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 25),
                      child: Image.asset(kLogoPNG),
                      decoration: BoxDecoration(
                        color: CColors.switchable(context,
                            dark: CColors.lightBlack,
                            light: CColors.secondary(context)),
                        borderRadius: const BorderRadiusDirectional.only(
                          bottomEnd: Radius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: _items.length,
                      separatorBuilder: (_, __) =>
                          const Divider(indent: 10, height: 0),
                      itemBuilder: (context, index) {
                        final _item = _items[index];

                        Widget? leading;
                        if (_item.icon != null) {
                          leading = IconTheme(
                            data: IconThemeData(
                              color: CColors.secondary(context),
                              size: 20,
                            ),
                            child: _item.icon!,
                          );
                        }
                        final item = TitleListTile(
                          onTap: () {
                            // Navigator.pop(context);
                            _item.onTap?.call();
                          },
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 10,
                          ),
                          style: Theme.of(context).textTheme.bodyLarge,
                          title: _item.title,
                          leading: leading,
                          trailing: _item.trailing,
                        );
                        if (_item.description == null || _item.key == null) {
                          return item;
                        }

                        return Showcase(
                          key: _item.key!,
                          description: _item.description,
                          child: item,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogoutCubit, LogoutState>(
      listener: (context, state) {
        // log('context.watch<FetchDataCubit>().state.user.uuid ${context.watch<FetchDataCubit>().state.user.uuid}');
        // FirebaseFirestore _firestore = FirebaseFirestore.instance;
        // WriteBatch batch = FirebaseFirestore.instance.batch();
        // DocumentReference<Map<String, dynamic>> _roomDoc = _firestore
        //     .collection(ROOMS_COLLECTION)
        //     .doc(context.watch<FetchDataCubit>().state.user.uuid);
        // CollectionReference<Map<String, dynamic>> _messagesCollection =
        //     _roomDoc.collection(MESSAGES_COLLECTION);
        // final doc = _messagesCollection.doc();
        // doc.da;
        if (state.isLoggedOut) {
          IAPController.get(context).logout();
          Navigator.pushAndRemoveUntil(
            context,
            FadePageRoute(builder: (_) => LogInScreen()),
            (route) => false,
          );
        } else if (state.isFailed) {
          Navigator.pop(context);
          final _state = state as LogoutFailed;
          IAPController.get(context).logout();
          Navigator.pushAndRemoveUntil(
            context,
            FadePageRoute(builder: (_) => LogInScreen()),
            (route) => false,
          );
          appLogger.e("Error logging out", _state.e);

          CSnackBar.failure(messageText: LocaleKeys.error_error_happened.tr())
              .showWithoutContext();
        }
      },
      builder: (context, state) {
        if (state.isLoading) return const LoadingDialog();
        return AlertDialog(
          surfaceTintColor: Colors.transparent,
          title: Text(LocaleKeys.auth_logout_are_you_sure.tr()),
          content: Text(LocaleKeys.auth_logout_are_you_sure_desc.tr()),
          actions: [
            TextButton(
              onPressed: () => context.read<LogoutCubit>().logoutSubmitted(),
              child: Text(
                LocaleKeys.auth_logout_title.tr(),
                style: theme(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Colors.red),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                visualDensity: VisualDensity.comfortable,
                backgroundColor: CColors.primary(context),
                foregroundColor:
                    CColors.nullableSwitchable(context, dark: Colors.black),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(LocaleKeys.general_titles_cancel.tr()),
            ),
          ],
        );
      },
    );
  }
}

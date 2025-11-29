import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart' as urllauncher;
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Helpers/network.dart';
import 'package:the_coach/Modules/Payment/payment.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';
import 'package:the_coach/appsflyer_global.dart';

class MySubscription extends StatefulWidget {
  const MySubscription({Key? key}) : super(key: key);

  @override
  _MySubscriptionState createState() => _MySubscriptionState();
}

class _MySubscriptionState extends State<MySubscription> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchSubscriptionInfoCubit>().fetchSubscriptionInfo();
    });
    super.initState();
  }

  Future<void> _handleOnFreeTrialEnded() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FreeTrialEnded(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BuyOfferingCubit, BuyOfferingState>(
      listener: (context, state) async {
        if (state is BuyOfferingSucceeded) {
          CSnackBar.success(
            messageText: LocaleKeys.payment_subscribed_title.tr(),
            avoidNavigationBar: false,
          ).show(context);
          await appsFlyerGlobal.logEvent('af_purchase', {
            "package": state.packageName,
            "originalAppUserId": state.userId
          });
        } else if (state is BuyOfferingFailure) {
          String msg = LocaleKeys.error_error_happened + ':${state.e}}';
          if (state.e is PaymentException) {
            final details = (state.e as PaymentException).details;
            if (details != null) msg = details;
          }
          CSnackBar.failure(
            messageText: msg,
            avoidNavigationBar: false,
          ).show(context);
        }
      },
      child: Scaffold(
        appBar: CAppBar(header: LocaleKeys.payment_general_subscriptions.tr()),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: [
                  Expanded(
                    child: BlocBuilder<FetchSubscriptionInfoCubit,
                        FetchSubscriptionInfoState>(
                      builder: (context, state) {
                        if (state is FetchSubscriptionInfoFailure) {
                          final error = state.e;
                          String message = state.e.toString();
                          String code = '000';
                          String details = '';

                          if (error is PaymentException) {
                            message = error.details ?? message;
                            code = error.code;
                            details = error.details ?? '';
                          }
                          return Text(
                            LocaleKeys.error_error_happened_because.tr(
                              namedArgs: {'cause': "[$code] $message-$details"},
                            ),
                            textAlign: TextAlign.center,
                          );
                        } else if (state is FetchSubscriptionInfoSucceeded) {
                          return _buildSubscriptionInfoDetails(state.info);
                        } else if (state is FreeTrialEndedWithNoSubscription) {
                          return _buildMustSubscribeView();
                        } else if (state is StillInFreeTrial) {
                          return _buildFreeTrialView(
                              state.remainingTimeInSecondes);
                        }
                        return const SizedBox.square(
                          dimension: 30,
                          child: Center(
                              child: CircularProgressIndicator.adaptive()),
                        );
                      },
                    ),
                  ),
                  const Space.v5(),
                  TextButton(
                    onPressed: launchTermsOfService,
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                    child:
                        Text(LocaleKeys.drawer_settings_terms_of_service.tr()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionInfoDetails(SubscriptionInfo info) {
    final purchaseDate =
        info.latestPurchasedAt.toLocalizedDateTimeStr(locale: context.locale);
    final expirationDate =
        info.expiresAt?.toLocalizedDateTimeStr(locale: context.locale);

    return Column(
      children: [
        Icon(
          Icons.star_border,
          color: CColors.secondary(context),
          size: screenSize.width / 2,
        ),
        const Space.v30(),
        Text(
          LocaleKeys.payment_subscribed_details_started_at.tr(
            namedArgs: {'date': purchaseDate},
          ),
        ),
        const Space.v5(),
        Text(
          LocaleKeys.payment_subscribed_title.tr(),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: CColors.nullableSwitchable(context, light: Colors.black),
              ),
          textAlign: TextAlign.center,
        ),
        const Space.v20(),
        Text(
          LocaleKeys.payment_subscribed_details_end_at.tr(
            namedArgs: {'date': expirationDate ?? ""},
          ),
        ),
        if (info.managementUrl != null) ...[
          const Space.v15(),
          TextButton(
            onPressed: () async {
              final url = Uri.parse(info.managementUrl!);
              await urllauncher.launchUrl(
                url,
                mode: urllauncher.LaunchMode.externalApplication,
              );
            },
            child: Text(LocaleKeys.payment_general_manage_subscription.tr()),
          ),
        ],
        if (kDebugMode) ...[
          TextButton(
            onPressed: () {
              log(info.toString());
            },
            child: Text("DETAILS"),
          ),
        ],
      ],
    );
  }

  Widget _buildMustSubscribeView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  color: CColors.primary(context),
                  size: screenSize.width / 2,
                ),
                Text(
                  LocaleKeys.payment_free_trail_ended_title.tr(),
                  style: theme(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const Space.v10(),
                Text(
                  LocaleKeys.payment_free_trail_ended_content.tr(),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const Space.v10(),
        const SubscribeNowButton(),
      ],
    );
  }

  Widget _buildFreeTrialView(int remainingTimeInSeconds) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.star,
                        color: CColors.primary(context),
                        size: 40,
                      ),
                      const Space.h10(),
                      Icon(
                        FontAwesomeIcons.solidStar,
                        color: CColors.primary(context),
                        size: 60,
                      ),
                      const Space.h10(),
                      Icon(
                        FontAwesomeIcons.star,
                        color: CColors.primary(context),
                        size: 40,
                      ),
                    ],
                  ),
                ),
                const Space.v20(),
                Text(
                  LocaleKeys.payment_general_in_free_trial.tr(),
                  style: theme(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const Space.v30(),
                Column(
                  children: [
                    Text(
                      LocaleKeys.payment_general_you_have.tr(),
                      style: theme(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    FreeTrialTimer(
                      totalSeconds: remainingTimeInSeconds,
                      textStyle:
                          theme(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: CColors.nullableSwitchable(context,
                                    light: Colors.black),
                              ),
                      onFinished: _handleOnFreeTrialEnded,
                    ),
                    Text(
                      LocaleKeys.payment_general_of_free_days.tr(),
                      style: theme(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      LocaleKeys.payment_general_after_the_free_period.tr(),
                      textAlign: TextAlign.center,
                      style: theme(context).textTheme.bodySmall!.copyWith(
                            fontSize: 11,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Space.v30(),
        SubscribeNowButton(
          enable: true,
        ),
      ],
    );
  }
}

import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:the_coach/Screens/screens.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/constants.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import 'subscribe_now.dart';

class FreeTrialEnded extends StatefulWidget {
  const FreeTrialEnded({Key? key}) : super(key: key);

  @override
  State<FreeTrialEnded> createState() => _FreeTrialEndedState();
}

class _FreeTrialEndedState extends State<FreeTrialEnded> {
  bool _skip = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BuyOfferingCubit, BuyOfferingState>(
      listener: (context, state) async {
        if (state is BuyOfferingSucceeded) {
          Navigator.pop(context);
          CSnackBar.success(
                  messageText: LocaleKeys.success_payment_success.tr())
              .showWithoutContext();
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
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            if (_skip) return true;
            if (state is BuyOfferingSucceeded) {
              return true;
            }
            return false;
          },
          child: Scaffold(
            appBar: CAppBar(
              header: LocaleKeys.payment_free_trail_ended_title.tr(),
              leading: _buildLogoutBtn(),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              kSubscriptionSVG2,
                              width: screenSize.width / 1.5,
                            ),
                            const Space.v20(),
                            Text(
                              LocaleKeys
                                  .payment_subscription_expired_description
                                  .tr(),
                              style: theme(context).textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SubscribeNowButton(),
                    // ContinueWithAdsButton(onPressed: () {
                    //   _skip = true;
                    //   Navigator.pop(context);
                    // }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoutBtn() {
    return IconButton(
      onPressed: () {
        context.read<LogoutCubit>().logoutSubmitted();
        IAPController.get(context).logout();
        Navigator.pushAndRemoveUntil(
          context,
          FadePageRoute(builder: (_) => LogInScreen()),
          (route) => false,
        );
      },
      icon: Icon(Icons.logout),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/constants.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import 'subscribe_now.dart';

class SubscriptionExpired extends StatefulWidget {
  const SubscriptionExpired({Key? key}) : super(key: key);

  @override
  _SubscriptionExpiredState createState() => _SubscriptionExpiredState();
}

class _SubscriptionExpiredState extends State<SubscriptionExpired> {
  bool _skip = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BuyOfferingCubit, BuyOfferingState>(
      listener: (context, state) async {
        if (state is BuyOfferingSucceeded) {
          return Navigator.pop(context);
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
              header: LocaleKeys.payment_subscription_expired_title.tr(),
              leading: const _LogoutButton(),
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
                              kSubscriptionSVG1,
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
                    SubscribeNowButton(
                      title: LocaleKeys
                          .payment_subscription_expired_subscribe_again
                          .tr(),
                    ),
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
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(context: context, builder: (_) => LogoutDialog());
      },
      icon: Icon(
        Icons.logout_outlined,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Modules/Payment/payment.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

class FreeTrialDialog extends StatelessWidget {
  final int remainingTimeInSecondes;
  final VoidCallback? onFreeTrialEnded;

  const FreeTrialDialog({
    Key? key,
    required this.remainingTimeInSecondes,
    this.onFreeTrialEnded,
  })  : assert(remainingTimeInSecondes > 0),
        super(key: key);

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
        return AlertDialog(
          surfaceTintColor: Colors.transparent,
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: CColors.switchable(context,
                          dark: Colors.white, light: CColors.splashBackground),
                    ),
                  ),
                ],
              ),
              Text(LocaleKeys.payment_general_in_free_trial.tr()),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text(
              //   LocaleKeys.payment_general_you_have.tr(),
              //   style: theme(context).textTheme.headlineSmall,
              //   textAlign: TextAlign.center,
              // ),
              Text(
                LocaleKeys.payment_general_enjoy_completely.tr(),
                textAlign: TextAlign.center,
                style: theme(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 5),
              FreeTrialTimer(
                totalSeconds: remainingTimeInSecondes,
                onFinished: onFreeTrialEnded,
                textStyle: theme(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: CColors.primary(context),
                    ),
              ),
              Text(
                LocaleKeys.payment_general_of_free_days.tr(),
                textAlign: TextAlign.center,
                style: theme(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 5),
              Text(
                LocaleKeys.payment_general_after_the_free_period.tr(),
                textAlign: TextAlign.center,
                style: theme(context).textTheme.bodySmall!.copyWith(
                      fontSize: 9,
                    ),
              ),
              const SizedBox(height: 16),
              // const SubscribeNowButton(),
            ],
          ),
        );
      },
    );
  }
}

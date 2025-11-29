import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Modules/Payment/payment.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

class SubscribeNowButton extends StatefulWidget {
  final String? title;
  final VoidCallback? onTapStarted;
  final bool enable;
  const SubscribeNowButton({
    Key? key,
    this.title,
    this.onTapStarted,
    this.enable = true,
  }) : super(key: key);

  @override
  _SubscribeNowButtonState createState() => _SubscribeNowButtonState();
}

class _SubscribeNowButtonState extends State<SubscribeNowButton> {
  Future<void> _handleSubscriptionEvent() async {
    final buyCubit = context.read<BuyOfferingCubit>();
    if (buyCubit.state.isInProgress) return;
    widget.onTapStarted?.call();

    context.read<FetchPackagesCubit>().displayPackages();
    final result = await showModalBottomSheet<Package>(
      context: context,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: const Radius.circular(20.0),
        ),
      ),
      builder: (_) => const OfferingSheet(),
    );
    if (result == null) return;
    buyCubit.buyOffering(result);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BuyOfferingCubit, BuyOfferingState>(
      builder: (context, state) {
        final bool isLoading = state.isInProgress;

        Widget icon = Icon(Icons.check);
        if (isLoading) {
          icon = CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              CColors.switchable(
                context,
                dark: Colors.black,
                light: Colors.white,
              ),
            ),
          );
        }

        return ElevatedButton.icon(
          onPressed: widget.enable ? _handleSubscriptionEvent : null,
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            backgroundColor:
                widget.enable ? CColors.primary(context) : Colors.transparent,
            foregroundColor:
                CColors.nullableSwitchable(context, dark: Colors.black),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          icon: SizedBox.square(dimension: 20, child: icon),
          label: Text(
            widget.title ?? LocaleKeys.payment_general_subscribe_now.tr(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}

class ContinueWithAdsButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ContinueWithAdsButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.payment_free_trail_ended_continue_with_ads.tr(),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            IconDirectional(Icons.chevron_left),
          ],
        ),
      ),
    );
  }
}

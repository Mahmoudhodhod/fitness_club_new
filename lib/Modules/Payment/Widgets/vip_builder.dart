import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

typedef VipWidgetBuilder = Widget Function(BuildContext context, bool isVip);

class VIPBuilder extends StatelessWidget {
  final VipWidgetBuilder builder;
  const VIPBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: [VIP]
    return builder(context, true);
    final isAdmin = context.watch<FetchDataCubit>().state.user.isAdmin;
    if (isAdmin) return builder(context, true);

    return BlocBuilder<FetchSubscriptionInfoCubit, FetchSubscriptionInfoState>(
      builder: (context, state) {
        final isVip = state is FetchSubscriptionInfoSucceeded;
        return builder(context, isVip);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/src/Blocs/blocs.dart';
import 'package:in_app_purchase/src/Controllers/controllers.dart';

class IAPBlocProviders extends StatelessWidget {
  final Widget child;
  const IAPBlocProviders({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _iapController = IAPController.get(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FetchPackagesCubit(controller: _iapController)),
        BlocProvider(create: (_) => FetchSubscriptionInfoCubit(controller: _iapController)),
        BlocProvider(create: (_) => WatchSubscriberInfoChangeCubit(_iapController)),
        BlocProvider(create: (_) => DisplaySubscriptionReminderViewCubit(controller: _iapController)),
        BlocProvider(create: (_) => FetchSubscriptionStatusCubit(controller: _iapController)),
      ],
      child: BlocProvider(
        create: (context) => BuyOfferingCubit(
          controller: _iapController,
          subscriptionInfoCubit: context.read<FetchSubscriptionInfoCubit>(),
        ),
        child: child,
      ),
    );
  }
}

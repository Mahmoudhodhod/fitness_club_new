import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/src/Controllers/controllers.dart';
import 'package:in_app_purchase/src/Repositories/repositories.dart';

class IAPRepositoryProviders extends StatelessWidget {
  final Widget child;
  const IAPRepositoryProviders({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _IPAControllerProvider(
      purchaseAPI: PurchaseAPI(),
      userInfo: UserSubscriptionInfo(),
      child: child,
    );
  }
}

class _IPAControllerProvider extends StatelessWidget {
  final Widget child;
  final UserSubscriptionInfo userInfo;
  final PurchaseAPI purchaseAPI;
  const _IPAControllerProvider({
    Key? key,
    required this.child,
    required this.userInfo,
    required this.purchaseAPI,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => IAPController(
        purchaseAPI: purchaseAPI,
        userSubscriptionInfo: userInfo,
      ),
      child: child,
    );
  }
}

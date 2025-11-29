import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:in_app_purchase/env.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase/src/Utilities/exceptions.dart';
import 'package:in_app_purchase/src/logger.dart';
import 'package:purchases_flutter/object_wrappers.dart';

//TODO: document
class IAPController {
  final UserSubscriptionInfo _userInfo;
  final PurchaseAPI _purchaseAPI;

  late List<Package> _availablePackages;

  IAPController({
    required UserSubscriptionInfo userSubscriptionInfo,
    required PurchaseAPI purchaseAPI,
  })  : _userInfo = userSubscriptionInfo,
        _purchaseAPI = purchaseAPI {
    _availablePackages = [];
  }

  static IAPController get(BuildContext context) {
    return context.read();
  }

  Future<void> initPurchases({bool debugMode = false, String? appUserId}) {
    return _purchaseAPI.init(debugMode: debugMode, appUserId: appUserId);
  }

  //ignore: use_setters_to_change_properties
  void getSubscriber(FetchCurrentSubscriber fetchCurrentSubscriber) {
    _userInfo.getSubscriber = fetchCurrentSubscriber;
  }

  Future<bool> isUserFreeTrialEnded() async {
    return await _userInfo.isUserFreeTrialEnded();
  }

  Future<int> freeTrialRemainingTimeInSeconds() async {
    return _userInfo.freeTrialRemainingTimeInSeconds();
  }

  Future<void> login(Subscriber u) {
    return _purchaseAPI.login(u);
  }

  Future<void> logout() async {
    try {
      await _purchaseAPI.logout();
    } on Exception catch (e, stacktrace) {
      logger.e("Error while logging out the current user", e, stacktrace);
    }
  }

  Future<List<Package>> fetchSubscriptionPackages() async {
    final packages = await _purchaseAPI.fetchPackages();
    _updateAvailablePackages = packages;
    return packages;
  }

  set _updateAvailablePackages(List<Package> packages) {
    _availablePackages = packages;
  }

  Future<CustomerInfo?> makePurchase(Package package) async {
    final isPackageExist = _doPackageExist(package);
    if (!isPackageExist) throw NoPackageFoundToPurchase(package.identifier);
    return _purchaseAPI.makePurchase(package);
  }

  bool _doPackageExist(Package package) {
    final packageID = package.identifier;
    final offeringID = package.offeringIdentifier;
    try {
      _availablePackages.firstWhere((p) {
        return (p.identifier == packageID) &&
            (p.offeringIdentifier == offeringID);
      });
    } catch (e, stacktrace) {
      logger.e(e.toString(), e, stacktrace);
      return false;
    }
    return true;
  }

  Future<bool> isSubscribedTo(String offering) =>
      _purchaseAPI.isSubscribedTo(offering);
  Future<bool> hasAnyActiveSubscription() =>
      _purchaseAPI.hasAnyActiveSubscription();

  Future<SubscriptionInfo?> fetchPurchaserInfo() async {
    final isAdmin = await _userInfo.isSubscribeAnAdmin();
    if (isAdmin) throw const SubscriberIsAdmin();
    await _purchaseAPI.getPurchaserInfo();
    final info = _purchaseAPI.purchaserInfo;
    return info?.toSubscriptionInfo(entitlementId: ENTITLEMENT_ID);
  }

  void listenToSubscriptionInfoUpdates(
    SubscriptionInfoUpdateListener infoUpdateListener,
  ) {
    _purchaseAPI.listenToSubscriptionInfoUpdates(infoUpdateListener);
  }
}

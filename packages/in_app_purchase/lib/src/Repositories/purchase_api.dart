import 'dart:io';

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';
import 'package:in_app_purchase/env.dart';
import 'package:in_app_purchase/src/Controllers/controllers.dart';
import 'package:in_app_purchase/src/Models/models.dart';
import 'package:in_app_purchase/src/Utilities/exceptions.dart';
import 'package:in_app_purchase/src/logger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

export 'package:purchases_flutter/purchases_flutter.dart' show Package;

typedef SubscriptionInfoUpdateListener = void Function(SubscriptionInfo info);

class PurchaseAPI {
  final Purchase _purchase;

  CustomerInfo? _purchaserInfo;
  CustomerInfo? get purchaserInfo => _purchaserInfo;

  PurchaseAPI({
    Purchase? purchase,
  }) : _purchase = purchase ?? Purchase();

  Future<void> init({bool debugMode = false, String? appUserId}) async {
    
    // await Purchases.setLogLevel(LogLevel.error);

    late PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(ANDROID_API_KEY);
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration(IOS_API_KEY);
    } else {
      throw UnimplementedError('[Purchases] Platform not supported');
    }
    await Purchases.configure(configuration);
  }

  Future<void> login(Subscriber u) async {
    await _purchase.loginUser(u);
    return Future<void>.value();
  }

  Future<void> logout() async {
    await _purchase.logoutUser();
    _purchaserInfo = null;
    return Future<void>.value();
  }

  Future<List<Package>> fetchPackages() async {
    try {
      final offerings = await _purchase.getOfferings();
      return offerings.current?.availablePackages ?? [];
    } on PlatformException catch (e, stacktrace) {
      logger.e(e.message ?? '', e, stacktrace);
      return [];
    }
  }

  Future<CustomerInfo?> makePurchase(Package package) async {
    try {
      _purchaserInfo = await _purchase.purchasePackage(package);

      return purchaserInfo;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        return null;
      }
      throw PurchasePackageFailure(
        message: e.message ?? "-",
        pError: PurchasesErrorHelper.getErrorCode(e),
      );
    }
  }

  @visibleForTesting
  Future<CustomerInfo?> getAllPurchaserInfoDirectly() async {
    return _purchase.getPurchaserInfo();
  }

  @visibleForTesting
  Future<String?> appUserID() {
    return _purchase.appUserID();
  }

  Future<bool> hasAnyActiveSubscription() async {
    await getPurchaserInfo();
    return _purchaserInfo?.entitlements.all.isNotEmpty ?? false;
  }

  Future<bool> isSubscribedTo(String offering) async {
    await getPurchaserInfo();
    return _purchaserInfo?.entitlements.all[offering]?.isActive ?? false;
  }

  Future<void> getPurchaserInfo() async {
    if (_purchaserInfo == null) {
      _purchaserInfo = await _restorePurchases();
      return;
    }

    try {
      _purchaserInfo = await _purchase.getPurchaserInfo();
      logger.d("PurchaserInfo: ${_purchaserInfo?.entitlements.all}");
    } on PlatformException catch (e, stacktrace) {
      logger.e(e.message, e, stacktrace);
      final err = PurchasesErrorHelper.getErrorCode(e);
      if (err == PurchasesErrorCode.missingReceiptFileError && Platform.isIOS) {
        return;
      }
      throw FetchPurchaserInfoFailure(message: e.message ?? "-", pError: err);
    }
  }

  Future<CustomerInfo?> _restorePurchases() async {
    try {
      final restoredInfo = await _purchase.restoreTransactions();
      return restoredInfo;
    } on PlatformException catch (e, stacktrace) {
      logger.e(e.message, e, stacktrace);
      final err = PurchasesErrorHelper.getErrorCode(e);
      if (err == PurchasesErrorCode.missingReceiptFileError && Platform.isIOS) {
        return null;
      }
      throw RestoringPurchaserInfoFailure(message: e.message ?? "-", err: err);
    }
  }

  void listenToSubscriptionInfoUpdates(SubscriptionInfoUpdateListener infoUpdateListener) {
    _purchase.addPurchaserInfoUpdateListener((purchaserInfo) {
      final subscription = purchaserInfo.toSubscriptionInfo(entitlementId: ENTITLEMENT_ID);
      infoUpdateListener(subscription!);
    });
  }
}

extension ToSubscriptionInfo on CustomerInfo {
  SubscriptionInfo? toSubscriptionInfo({required String entitlementId}) {
    final entitlement = entitlements.all[entitlementId];
    if (entitlement == null) return null;
    final store = _fromStoreToPurchaseStore(entitlement);
    assert(store != null);
    return SubscriptionInfo(
      store: store!,
      managementUrl: managementURL,
      productId: entitlement.productIdentifier,
      isActive: entitlement.isActive,
      isSandbox: entitlement.isSandbox,
      latestPurchasedAt: DateTime.parse(entitlement.latestPurchaseDate),
      originalPurchasedAt: DateTime.parse(entitlement.originalPurchaseDate),
      expiresAt: DateTime.tryParse(entitlement.expirationDate ?? ''),
      bellingIssuedAt: DateTime.tryParse(entitlement.billingIssueDetectedAt ?? ''),
      unSubscribedAt: DateTime.tryParse(entitlement.unsubscribeDetectedAt ?? ''),
    );
  }

  PurchaseStore? _fromStoreToPurchaseStore(EntitlementInfo entitlementInfo) {
    switch (entitlementInfo.store) {
      case Store.appStore:
        return PurchaseStore.AppStore;
      case Store.playStore:
        return PurchaseStore.PlayStore;
      default:
        return null;
    }
  }
}

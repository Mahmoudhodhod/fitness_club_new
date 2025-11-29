import 'package:in_app_purchase/src/Models/models.dart';
import 'package:in_app_purchase/src/logger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseUser {
  final String id;
  final String name;
  final String email;
  const PurchaseUser({
    required this.id,
    required this.name,
    required this.email,
  });
}

/// Entry point for In app Purchases integration.
class Purchase {
  static final Purchase _singleton = Purchase._internal();

  /// Entry point for In app Purchases integration.
  factory Purchase() => _singleton;
  Purchase._internal();

  ///Enables/Disables debugs logs
  Future<void> setDebugLogsEnabled({bool enabled = false}) {
    // ignore: deprecated_member_use
    return Purchases.setDebugLogsEnabled(enabled);
  }

  /// This function will logIn the current user with an appUserID.
  /// Typically this would be used after logging in a user to identify them without
  /// calling configure
  ///
  /// Returns a [LogInResult] object, or throws a [PlatformException] if there
  /// was a problem restoring transactions. LogInResult holds a PurchaserInfo object
  /// and a bool that can be used to know if a user has just been created for the first time.
  ///
  /// [newAppUserID] The appUserID that should be linked to the currently user
  Future<LogInResult> loginUser(Subscriber user) async {
    final res = await Purchases.logIn(user.uuid);
    await Purchases.setDisplayName(user.name);
    await Purchases.setEmail(user.email);
    return res;
  }

  /// Gets the current appUserID.
  Future<String> appUserID() {
    return Purchases.appUserID;
  }

  /// Logs out the  Purchases client, clearing the saved appUserID. This will
  /// generate a random user id and save it in the cache.
  ///
  /// Returns a [PurchaserInfo] object, or throws a [PlatformException] if there
  /// was a problem restoring transactions or if the method is called while the
  /// current user is anonymous.
  Future<void> logoutUser() async {
    await Purchases.setEmail("");
    await Purchases.setDisplayName("");
    await Purchases.logOut();
  }

  /// Fetch the configured offerings for this users. Offerings allows you to
  /// configure your in-app products via RevenueCat and greatly simplifies
  /// management. See [the guide](https://docs.revenuecat.com/offerings) for
  /// more info.
  ///
  /// Offerings will be fetched and cached on instantiation so that, by the time
  /// they are needed, your prices are loaded for your purchase flow.
  ///
  /// Time is money.
  Future<Offerings> getOfferings() async {
    return Purchases.getOfferings();
  }

  /// Makes a purchase. Returns a [PurchaserInfo] object. Throws a
  /// [PlatformException] if the purchase is unsuccessful.
  /// Check if `PurchasesErrorHelper.getErrorCode(e)` is
  /// `PurchasesErrorCode.purchaseCancelledError` to check if the user cancelled
  /// the purchase.
  ///
  /// [packageToPurchase] The Package you wish to purchase
  ///
  /// [upgradeInfo] Android only. Optional UpgradeInfo you wish to upgrade from
  /// containing the oldSKU and the optional prorationMode.
  Future<CustomerInfo> purchasePackage(
    Package packageToPurchase, {
    UpgradeInfo? upgradeInfo,
  }) async {
    return Purchases.purchasePackage(packageToPurchase, upgradeInfo: upgradeInfo);
  }

  /// Gets current purchaser info, which will normally be cached.
  Future<CustomerInfo> getPurchaserInfo() async {
    return Purchases.getCustomerInfo();
  }

  /// Restores a user's previous purchases and links their appUserIDs to any
  /// user's also using those purchases.
  ///
  /// Returns a [PurchaserInfo] object, or throws a [PlatformException] if there
  /// was a problem restoring transactions.
  Future<CustomerInfo> restoreTransactions() async {
    return Purchases.restorePurchases();
  }

  /// Sets a function to be called on updated purchaser info.
  ///
  /// The function is called right away with the latest purchaser info as soon
  /// as it's set.
  ///
  /// [purchaserInfoUpdateListener] PurchaserInfo update listener.
  void addPurchaserInfoUpdateListener(CustomerInfoUpdateListener infoListener) {
    Purchases.addCustomerInfoUpdateListener((info) {
      logger.d(info);
      infoListener(info);
    });
  }
}

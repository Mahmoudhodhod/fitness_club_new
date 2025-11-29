import 'package:equatable/equatable.dart';

enum PurchaseStore { AppStore, PlayStore }

class SubscriptionInfo extends Equatable {
  final String productId;
  final bool isActive;

  final bool isSandbox;
  final PurchaseStore store;
  final String? managementUrl;

  final DateTime latestPurchasedAt;
  final DateTime originalPurchasedAt;

  final DateTime? expiresAt;
  final DateTime? bellingIssuedAt;
  final DateTime? unSubscribedAt;

  const SubscriptionInfo({
    required this.productId,
    required this.isActive,
    required this.isSandbox,
    required this.store,
    this.managementUrl,
    required this.latestPurchasedAt,
    required this.originalPurchasedAt,
    this.expiresAt,
    this.bellingIssuedAt,
    this.unSubscribedAt,
  });

  bool get isExpired => !isActive;

  @override
  List<Object?> get props {
    return [
      productId,
      managementUrl,
      isActive,
      isSandbox,
      store,
      latestPurchasedAt,
      originalPurchasedAt,
      expiresAt,
      bellingIssuedAt,
      unSubscribedAt,
    ];
  }

  @override
  bool? get stringify => true;
}

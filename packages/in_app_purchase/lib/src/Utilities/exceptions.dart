import 'package:purchases_flutter/errors.dart';

class PaymentException implements Exception {
  final String code;
  final String? details;
  final PurchasesErrorCode pErr;

  const PaymentException({
    required this.code,
    this.details,
    this.pErr = PurchasesErrorCode.unknownError,
  });

  @override
  String toString() {
    if (details == null) {
      return "PaymentException(code: $code, err: ${pErr.name})";
    }
    return "PaymentException(code: $code, details: $details, err: ${pErr.name})";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaymentException && other.code == code && other.details == details && other.pErr == pErr;
  }

  @override
  int get hashCode => code.hashCode ^ details.hashCode ^ pErr.hashCode;
}

class PurchasePackageFailure extends PaymentException {
  const PurchasePackageFailure({
    required String message,
    required PurchasesErrorCode pError,
  }) : super(
          code: 'PURCHASE_PACKAGE_FAILURE',
          details: message,
          pErr: pError,
        );
}

class FetchPurchaserInfoFailure extends PaymentException {
  const FetchPurchaserInfoFailure({
    required String message,
    required PurchasesErrorCode pError,
  }) : super(
          code: 'FETCHING_PURCHASER_INFO_FAILURE',
          details: message,
          pErr: pError,
        );
}

class RestoringPurchaserInfoFailure extends PaymentException {
  const RestoringPurchaserInfoFailure({
    required String message,
    required PurchasesErrorCode err,
  }) : super(
          code: 'RESTORING_PURCHASES_FAILURE',
          details: message,
          pErr: err,
        );
}

class BadRequestParametersFailure extends PaymentException {
  const BadRequestParametersFailure(String details)
      : super(
          code: 'REVENUE_CAT_BAD_REQUEST_FAILURE',
          details: details,
        );
}

class InvalidRevenueCatAPIKeyFailure extends PaymentException {
  const InvalidRevenueCatAPIKeyFailure(String details)
      : super(
          code: 'REVENUE_CAT_INVALID_REQUEST_FAILURE',
          details: details,
        );
}

class FetchingCurrentSubscriberInfoFailure extends PaymentException {
  const FetchingCurrentSubscriberInfoFailure() : super(code: 'FETCH_SUBSCRIBER_INFO_FAILURE');
}

class NoPackageFoundToPurchase extends PaymentException {
  const NoPackageFoundToPurchase(String packageId)
      : super(
          code: 'PACKAGE_NOT_FOUND_FAILURE',
          details: packageId,
        );
}

class FreeTrialEndedFailure extends PaymentException {
  const FreeTrialEndedFailure() : super(code: 'FREE_TRIAL_ENDED_FAILURE');
}

class SubscriberIsAdmin extends PaymentException {
  const SubscriberIsAdmin() : super(code: 'CURRENT_SUBSCRIBER_IS_ADMIN');
}

class AnonymousCurrentUser extends PaymentException {
  const AnonymousCurrentUser()
      : super(
          code: 'CURRENT_SUBSCRIBER_IS_ANONYMOUS',
          details: "Make sure you have already logged in the user.",
        );
}

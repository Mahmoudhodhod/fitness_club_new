import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/src/Controllers/controllers.dart';
import 'package:in_app_purchase/src/logger.dart';
import 'package:purchases_flutter/object_wrappers.dart';
import 'package:utilities/utilities.dart' show ErrorState;

part 'fetch_packages_state.dart';

class FetchPackagesCubit extends Cubit<FetchPackagesState> {
  final IAPController _iapController;
  FetchPackagesCubit({
    required IAPController controller,
  })  : _iapController = controller,
        super(const FetchPackagesInitial());

  Future<void> displayPackages() async {
    emit(const FetchPackagesInProgress());
    try {
      final offerings = await _iapController.fetchSubscriptionPackages();
      emit(FetchPackagesSucceeded(offerings));
    } catch (e, stacktrace) {
      logger.e(e, e, stacktrace);
      emit(FetchPackagesFialure(e));
    }
  }
}

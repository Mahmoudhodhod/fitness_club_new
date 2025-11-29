import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/src/Controllers/controllers.dart';
import 'package:in_app_purchase/src/Utilities/exceptions.dart';
import 'package:in_app_purchase/src/logger.dart';
import 'package:utilities/utilities.dart' show ErrorState;

part 'display_subscription_remider_view_state.dart';

class DisplaySubscriptionReminderViewCubit
    extends Cubit<DisplaySubscriptionRemiderViewState> {
  final IAPController _iapController;
  DisplaySubscriptionReminderViewCubit({
    required IAPController controller,
  })  : _iapController = controller,
        super(const DisplayDialogInitial());

  ///Check and see if the user is in
  ///
  ///* Free trial: display a reminder dialog to make him subscribe now.
  ///* Trial Ended: display a dialog to suggest to the user to subscribe to continue
  ///using the app.

  Future<void> displayView() async {
    try {
      /* check the api if the user is still in trail */
      final bool isTrialEnded = await _iapController.isUserFreeTrialEnded();
      //
      if (isTrialEnded) {
        /* trial has ended and the user has to subscribe */
        emit(const DisplayTrialEndView());
      } else {
        /* check the user remaining free trial in seconds */
        await _handleFreeTrialRemainingTime();
      }
    } on SubscriberIsAdmin {
      /* do nothing */
      return emit(const DisplayDialogInitial());
    } catch (e, stacktrace) {
      logger.e(e, e, stacktrace);
      emit(DisplayDialogFailure(e));
    }
  }

  Future<void> _handleFreeTrialRemainingTime() async {
    try {
      final int remainingSeconds =
          await _iapController.freeTrialRemainingTimeInSeconds();
      emit(DisplayTrailReminderView(remainingTimeInSecondes: remainingSeconds));
    } on FreeTrialEndedFailure {
      emit(const DisplayTrialEndView());
    }
  }
}

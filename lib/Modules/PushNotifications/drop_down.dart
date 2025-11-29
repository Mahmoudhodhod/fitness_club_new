import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

void showDropDown({required String title, required String body}) {
  final context = Get.context;
  if (context == null) return;
  Get.cSnackbar(
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 17, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text(body),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.white60,
              elevation: 0.0,
              margin: const EdgeInsets.all(0),
              child: SizedBox(width: 40, height: 5),
            ),
          ),
        ),
      ],
    ),
  );
}

extension on GetInterface {
  Future<T?>? showSnackbar<T>(GetBar snackbar) {
    return null;
  }

  void cSnackbar<T>({
    Widget? content,
    bool instantInit = true,
    SnackPosition? snackPosition,
    Widget? icon,
    bool? shouldIconPulse,
    double? maxWidth,
    double? borderRadius,
    Color? borderColor,
    double? borderWidth,
    Color? leftBarIndicatorColor,
    Gradient? backgroundGradient,
    TextButton? mainButton,
    OnTap? onTap,
    bool? isDismissible,
    bool? showProgressIndicator,
    DismissDirection? dismissDirection,
    AnimationController? progressIndicatorController,
    Color? progressIndicatorBackgroundColor,
    Animation<Color>? progressIndicatorValueColor,
    Curve? forwardAnimationCurve,
    Curve? reverseAnimationCurve,
    Duration? animationDuration,
    double? overlayBlur,
    SnackbarStatusCallback? snackbarStatus,
    Form? userInputForm,
  }) async {
    final getBar = GetBar(
      snackbarStatus: snackbarStatus,
      messageText: content,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      backgroundColor: Theme.of(Get.context!).colorScheme.background,
      barBlur: 30,
      duration: const Duration(seconds: 4),
      snackStyle: SnackStyle.GROUNDED,
      overlayColor: Colors.white,
      boxShadows: [
        BoxShadow(
          offset: Offset(0, 15),
          color: Colors.black.withOpacity(0.05),
          spreadRadius: 0.0,
          blurRadius: 15,
        ),
      ],
      margin: EdgeInsets.zero,
      snackPosition: snackPosition ?? SnackPosition.TOP,
      borderRadius: borderRadius ?? 15,
      icon: icon,
      shouldIconPulse: shouldIconPulse ?? true,
      maxWidth: maxWidth,
      borderColor: borderColor,
      borderWidth: borderWidth ?? 100,
      leftBarIndicatorColor: leftBarIndicatorColor,
      backgroundGradient: backgroundGradient,
      mainButton: mainButton,
      onTap: onTap,
      isDismissible: isDismissible ?? true,
      dismissDirection: dismissDirection ?? DismissDirection.vertical,
      showProgressIndicator: showProgressIndicator ?? false,
      progressIndicatorController: progressIndicatorController,
      progressIndicatorBackgroundColor: progressIndicatorBackgroundColor,
      progressIndicatorValueColor: progressIndicatorValueColor,
      forwardAnimationCurve: forwardAnimationCurve ?? Curves.easeOutCirc,
      reverseAnimationCurve: reverseAnimationCurve ?? Curves.easeOutCirc,
      animationDuration: animationDuration ?? Duration(seconds: 1),
      overlayBlur: overlayBlur ?? 0.0,
      userInputForm: userInputForm,
    );

    if (instantInit) {
      showSnackbar<T>(getBar);
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        showSnackbar<T>(getBar);
      });
    }
  }
}

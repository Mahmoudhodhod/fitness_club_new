import 'dart:async';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

const _kCountDownDuration = Duration(minutes: 1);

///Creates a very simple widget api to build a pin code field
///
///use global key [GlobalKey<PinCodeHolderState>] to access [validateAndGetCode] method.
///
class PinCodeHolder extends StatefulWidget {
  ///returns the current typed text in the fields
  final ValueChanged<String>? onChanged;

  /// returns the typed text when user presses done/next action on the keyboard.
  final ValueChanged<String>? onSubmitted;

  ///returns the typed text when all pins are set
  final ValueChanged<int?>? onCompleted;

  ///Triggered when the user asks to resend pin code.
  ///
  final VoidCallback? onResendCode;

  ///The count down duration, default to `60 secondes`.
  ///
  final Duration countDownDuration;

  ///Creates a very simple widget api to build a pin code field
  const PinCodeHolder({
    Key? key,
    this.onChanged,
    this.onSubmitted,
    this.onResendCode,
    this.onCompleted,
    this.countDownDuration = _kCountDownDuration,
  }) : super(key: key);

  @override
  State<PinCodeHolder> createState() => PinCodeHolderState();
}

class PinCodeHolderState extends State<PinCodeHolder> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _pinCodeFormController;
  late final StreamController<ErrorAnimationType> _errorController;
  late final CountdownController _cdController;

  @override
  void initState() {
    _formKey = GlobalKey();
    _pinCodeFormController = TextEditingController();
    _errorController = StreamController();
    _cdController = CountdownController(autoStart: true);
    super.initState();
  }

  int? validateAndGetCode() {
    if (!_formKey.currentState!.validate()) {
      _errorController.sink.add(ErrorAnimationType.shake);
      return null;
    }
    return int.tryParse(_pinCodeFormController.text);
  }

  void clear() {
    _pinCodeFormController.clear();
  }

  void _resendCode(bool showReset) {
    widget.onResendCode?.call();
    if (showReset) _cdController.restart();
  }

  @override
  void dispose() {
    _pinCodeFormController.dispose();
    _errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: KBorders.bc15),
      color: CColors.nullableSwitchable(context, light: Colors.grey.shade100),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPinTextField(),
            Space.v20(),
            _buildResendCounter(),
          ],
        ),
      ),
    );
  }

  Widget _buildResendCounter() {
    return Countdown(
      seconds: widget.countDownDuration.inSeconds,
      controller: _cdController,
      build: (context, time) {
        bool _showResetBottom = time.toInt() == 0;
        int _minutes = time >= 60 ? (time / 60).round() : 0;
        int _seconds = (time - _minutes * 60).round();
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextButton(
                  onPressed: !_showResetBottom
                      ? null
                      : () => _resendCode(_showResetBottom),
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(fontSize: 12),
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: CColors.primary(context),
                  ),
                  child:
                      Text(LocaleKeys.auth_password_recovery_resend_code.tr()),
                ),
              ),
              //can_resend_after
              Text(
                LocaleKeys.auth_password_recovery_can_resend_after.tr(
                  namedArgs: {
                    'time':
                        "$_minutes:${_seconds < 10 ? 0 : ''}${_seconds.toInt()}"
                  },
                ),
                style: theme(context).textTheme.bodySmall?.copyWith(
                      color: CColors.nullableSwitchable(context,
                          light: Colors.black),
                    ),
              ),
            ],
          ),
        );
      },
      interval: Duration(seconds: 1),
    );
  }

  Widget _buildPinTextField() {
    return Form(
      key: _formKey,
      child: Directionality(
        textDirection: ui.TextDirection.ltr,
        child: PinCodeTextField(
          appContext: context,
          autoFocus: true,
          controller: _pinCodeFormController,
          autoDisposeControllers: false,
          validator: (value) {
            final _value = value!.trim();
            if (_value.length != 4) return '';
            return null;
          },
          onSubmitted: widget.onSubmitted,
          onChanged: widget.onChanged ?? (_) => null,
          dialogConfig: DialogConfig(),
          length: 4,
          animationType: AnimationType.fade,
          keyboardAppearance: Brightness.dark,
          errorTextSpace: 0,
          errorAnimationController: _errorController,
          onCompleted: (value) => widget.onCompleted?.call(int.tryParse(value)),
          pinTheme: PinTheme(
            borderWidth: 1.3,
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(10),
            fieldHeight: 60,
            fieldWidth: 50,
            activeFillColor: Colors.black.withAlpha(30),
            inactiveFillColor: Colors.black.withAlpha(30),
            selectedFillColor: Colors.black.withAlpha(50),
            inactiveColor: Colors.transparent,
            selectedColor: Colors.transparent,
            activeColor: Colors.transparent,
            errorBorderColor: Colors.red,
          ),
          textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
          keyboardType: TextInputType.number,
          cursorColor: Colors.transparent,
          animationDuration: Duration(milliseconds: 200),
          backgroundColor: Colors.transparent,
          enableActiveFill: true,
        ),
      ),
    );
  }
}

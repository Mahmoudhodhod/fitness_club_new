import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

///Creates a [FormField] that contains a custom feel.
///
class CTextField extends StatefulWidget {
  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  ///The text field title.
  ///
  final String? title;

  /// Text that suggests what sort of input the field accepts.
  ///
  final String? hint;

  final TextInputType? keyboardType;

  ///Whether the form is able to receive user input.
  ///
  ///If false the text field is "disabled": it ignores taps and its decoration is rendered in grey.
  final bool enabled;

  ///The type of action button to use for the keyboard.
  final TextInputAction? textInputAction;

  final bool isRequired;

  ///An optional method that validates an input. Returns an error string
  ///to display if the input is invalid, or null otherwise.
  ///
  ///if the field is required and no validation is givin
  ///the default validation will be applied.
  final FormFieldValidator<String>? validator;

  ///An optional value to initialize the form field to, or null otherwise.
  ///
  ///if a controller is givin the initial value will be omitted.
  final String? initialValue;

  //The padding for the input decoration's container.
  final EdgeInsetsGeometry? contentPadding;

  ///The max characters length which the user can enter.
  ///
  final int? maxLength;

  ///Defaults to `theme(context).textTheme.caption` with [Colors.redAccent].
  ///
  final TextStyle? errorTextStyle;

  final List<TextInputFormatter>? inputFormatters;

  ///Creates a [FormField] that contains a custom feel.
  ///
  const CTextField({
    Key? key,
    this.controller,
    this.title,
    this.hint,
    this.keyboardType,
    this.enabled = true,
    this.textInputAction,
    this.isRequired = false,
    this.validator,
    this.initialValue,
    this.maxLength,
    this.contentPadding,
    this.errorTextStyle,
    this.inputFormatters,
  }) : super(key: key);

  @override
  _CTextFieldState createState() => _CTextFieldState();
}

class _CTextFieldState extends State<CTextField> {
  late final TextEditingController _textEditingController;
  String _defaultValidationText =
      LocaleKeys.error_validation_required_field.tr();
  bool _showPassword = false;

  bool get isNumber => widget.keyboardType == TextInputType.number;
  bool get isPhoneNumber => widget.keyboardType == TextInputType.phone;

  bool get _isNumberBased => isPhoneNumber || isNumber;

  @override
  void initState() {
    _showPassword = widget.keyboardType == TextInputType.visiblePassword;
    if (widget.controller != null) {
      _textEditingController = widget.controller!;
    } else {
      _textEditingController = TextEditingController(text: widget.initialValue);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller == null) _textEditingController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CTextField oldWidget) {
    if (oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != null) {
      _textEditingController.text = widget.initialValue!;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 5),
              child: Text.rich(
                TextSpan(
                  text: widget.title,
                  children: [
                    if (widget.isRequired)
                      TextSpan(
                        text: " * ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                  ],
                ),
                style: theme(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          const Space.v5(),
          _buildTextFieldBody(),
        ],
      ),
    );
  }

  Widget _buildTextFieldBody() {
    return ClipRRect(
      borderRadius: BorderRadius.zero,
      child: TextFormField(
        enabled: widget.enabled,
        controller: _textEditingController,
        validator: (value) {
          if (widget.validator == null) {
            if (widget.isRequired && value!.isEmpty)
              return _defaultValidationText;
          } else {
            return widget.validator?.call(value);
          }
          return null;
        },
        inputFormatters: [
          if (widget.inputFormatters != null) ...widget.inputFormatters!,
          if (isNumber) ...[FilteringTextInputFormatter.digitsOnly]
        ],
        autocorrect: false,
        enableSuggestions: false,
        textInputAction: widget.textInputAction,
        keyboardType: widget.keyboardType,
        obscureText: _showPassword,
        textDirection: !_isNumberBased ? null : ui.TextDirection.ltr,
        textAlign: !_isNumberBased ? TextAlign.start : TextAlign.end,
        decoration: _buildDecoration(),
        maxLength: widget.maxLength,
      ),
    );
  }

  InputDecoration _buildDecoration() {
    return InputDecoration(
      contentPadding: widget.contentPadding,
      counter: const SizedBox.shrink(),
      hintText: widget.hint,
      errorStyle: widget.errorTextStyle ??
          theme(context).textTheme.bodySmall?.copyWith(color: Colors.redAccent),
      suffixIcon: _buildShowPasswordButton(),
      filled: true,
      isDense: true,
      fillColor:
          CColors.nullableSwitchable(context, light: Colors.grey.shade200),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.red),
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget? _buildShowPasswordButton() {
    if (widget.keyboardType != TextInputType.visiblePassword) return null;
    return IconButton(
      onPressed: () {
        if (mounted) setState(() => _showPassword = !_showPassword);
      },
      color: CColors.secondary(context),
      iconSize: 15,
      icon: Icon(
        _showPassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
      ),
    );
  }
}

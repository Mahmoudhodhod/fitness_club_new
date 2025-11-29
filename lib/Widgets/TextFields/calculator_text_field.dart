import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

///Returns a Text Inpurt formater which prevents any Arablic
///text to be entered
TextInputFormatter filterOutArabic() {
  return FilteringTextInputFormatter.deny(arabicRegex);
}

///Creates a very simple text field which helps in the utilites caculators.
///
class CalculatorTextField extends StatelessWidget {
  ///Field title.
  final String title;

  ///Field hint.
  final String? hintText;

  ///Controls the text being edited.
  final TextEditingController? controller;

  ///Defaults to `TextInputType.numberWithOptions(decimal: true)`.
  final TextInputType? keyboardType;

  ///Formats the input text
  ///
  ///Filters any Arabic text by default.
  ///
  ///See also:
  ///* [filterArabic] filter Arablic text from the current text field.
  final List<TextInputFormatter>? inputFormatters;

  ///Validate the current entered text.
  final FormFieldValidator<String>? validator;

  ///Filter Arabic text, defailt to `true`
  final bool filterArabic;

  ///Filter non numeric text, defailt to `true`
  final bool filterNonNumric;

  ///Trigged when the text field entered text was changed.
  final ValueChanged<String?>? onChanged;

  ///Max input text length.
  final int? maxLength;

  ///Creates a very simple text field which helps in the utilites caculators.
  ///
  const CalculatorTextField({
    Key? key,
    required this.title,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.filterArabic = true,
    this.filterNonNumric = true,
    this.onChanged,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            style: theme(context).textTheme.bodyLarge,
          ),
        ),
        Space.h20(),
        Expanded(
          flex: 4,
          child: TextFormField(
            controller: controller,
            autocorrect: false,
            onChanged: onChanged,
            keyboardType:
                keyboardType ?? TextInputType.numberWithOptions(decimal: true),
            maxLength: maxLength,
            inputFormatters: [
              if (inputFormatters != null) ...inputFormatters!,
              if (keyboardType?.index == TextInputType.number.index)
                FilteringTextInputFormatter.digitsOnly,
              if (filterArabic) filterOutArabic(),
            ],
            decoration: InputDecoration(
              filled: true,
              hintText: hintText,
              fillColor: CColors.nullableSwitchable(context,
                  light: Colors.grey.shade200),
              counter: const SizedBox.shrink(),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: CColors.primary(context),
                ),
              ),
            ),
            validator: (value) {
              if (validator != null) return validator!.call(value);
              if (value!.isEmpty)
                return LocaleKeys.error_validation_required_field.tr();
              return null;
            },
          ),
        ),
      ],
    );
  }
}

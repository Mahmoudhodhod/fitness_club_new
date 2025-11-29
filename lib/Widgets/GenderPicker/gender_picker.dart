import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:authentication/authentication.dart';

import 'package:utilities/utilities.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

import 'base_gender_picker.dart';

///Gender changed callback
typedef GenderChanged = void Function(Gender gender);

///Give the user the option to choose his gender.
///
class GenderPicker extends StatelessWidget {
  ///The initialy selected gender, Defaults to `Gender.male`.
  final Gender? initialValue;

  /// Triggers on selection of gender changed.
  final GenderChanged onChanged;

  ///it the current field required
  final bool isRequired;

  ///Give the user the option to choose his gender.
  ///
  const GenderPicker({
    Key? key,
    required this.onChanged,
    this.initialValue,
    this.isRequired = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 5),
          child: Text.rich(
            TextSpan(
              text: LocaleKeys.general_titles_g_gender_title.tr(),
              children: [
                if (isRequired)
                  TextSpan(
                    text: " * ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
            style: theme(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Space.v5(),
        GenderPickerWithImage(
          onChanged: (gender) => onChanged.call(gender!),
          maleText: LocaleKeys.general_titles_g_gender.tr(gender: "male"),
          femaleText: LocaleKeys.general_titles_g_gender.tr(gender: "female"),
          selectedGender: initialValue ?? Gender.male,
          selectedGenderTextStyle: theme(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold) ??
              TextStyle(),
          unSelectedGenderTextStyle: theme(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.grey[500]) ??
              TextStyle(),
          //Stupid, I know!
          linearGradient: LinearGradient(colors: [Colors.white, Colors.white]),
          equallyAligned: true,
          animationDuration: Duration(milliseconds: 300),
          opacityOfGradient: 0.2,
          padding: const EdgeInsets.all(0.0),
          // isCircular: false,
          size: 50,
        ),
      ],
    );
  }
}

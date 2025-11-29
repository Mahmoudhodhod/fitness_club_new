import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_coach/Helpers/colors.dart';

import 'package:utilities/utilities.dart';

///Table row, displays the table row title and data.
@immutable
class InfoTableRow {
  final Key? key;

  ///Row title.
  final String title;

  ///Title style, if not givin, defaults to `InfoTable().titleStyle`
  ///if not, defaults to `theme(context).textTheme.headline6`.
  final TextStyle? titleStyle;

  ///Row details.
  final String? detailsText;

  ///Details text style, if not givin, defaults to `InfoTable().detailsTextStyle`
  ///if not, defaults to `theme(context).textTheme.headline6`.
  final TextStyle? detailsStyle;

  ///Details custom widget.
  final Widget? details;

  ///Row background filling color.
  ///
  ///defaults to the table view gradient colors.
  ///
  final Color? bgColor;

  ///Row relative padding to the other rows.
  ///
  final EdgeInsetsGeometry? padding;

  ///Table row, displays the table row title and data.
  const InfoTableRow({
    this.key,
    required this.title,
    this.detailsText,
    this.detailsStyle,
    this.details,
    this.bgColor,
    this.titleStyle,
    this.padding,
  }) : assert(
          detailsText == null || details == null,
          "You should only use [detailsText] or [details] not both.",
        );
}

///Info table to display sub-exercises details in a very simple formate.
///
class InfoTable extends StatelessWidget {
  ///Table rows.
  ///
  final List<InfoTableRow> rows;

  ///info row gradient.
  final List<Color>? rowsGradient;

  ///Table border radius, defaults to `Radius.circular(5)`.
  final BorderRadius? borderRadius;

  ///Table padding, defaults to `EdgeInsets.all(10.0)`
  final EdgeInsetsGeometry? padding;

  ///Title style, uses it if  `InfoTableRow().titleStyle` not givin
  ///if not table title style not givin, defaults
  ///to `theme(context).textTheme.headline6`.
  final TextStyle? titleStyle;

  ///Title style, uses it if  `InfoTableRow().detailsStyle` not givin
  ///if not table title style not givin, defaults
  ///to `theme(context).textTheme.headline6`.
  final TextStyle? detailsTextStyle;

  ///Raw sections flex,
  ///* Must be a list of two numbers (ex: `[1, 2]`)
  ///* Must not have any zeros (ex: `[0, 1]` -> INVALID).
  ///
  final List<int>? flex;

  ///Info table to display sub-exercises details in a very simple formate.
  ///
  const InfoTable({
    Key? key,
    required this.rows,
    this.rowsGradient,
    this.borderRadius,
    this.padding,
    this.titleStyle,
    this.detailsTextStyle,
    this.flex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEnglish = context.locale.isEnglish;
    final fontScaleFactor = MediaQuery.of(context).textScaleFactor;
    final fontSize = 12 * fontScaleFactor * (isEnglish ? 1.3 : 1);

    String replaceFarsiNumber(String input) {
      if (context.locale.isArabic) {
        const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
        const farsi = ['۰', '۱', '۲', '۳', '٤', '٥', '٦', '۷', '۸', '۹'];

        for (int i = 0; i < english.length; i++) {
          input = input.replaceAll(english[i], farsi[i]);
        }
      }
      return input;
    }

    if (flex != null) {
      assert(
          flex!.length == 2,
          "flex must be to elements list representing "
          "the available to columns");
      assert(
        !flex!.contains(0),
        "flex must not have any zero element",
      );
    }
    final _flex = flex ?? [1, 2];
    if (rowsGradient != null)
      assert(
        rowsGradient!.length >= 2,
        "Row's Color gradients must be at least two colors.",
      );
    final _rowsGradient = rowsGradient ??
        CColors.switchableObject(
          dark: [Colors.black12, Colors.black26],
          light: [Colors.grey.shade100, Colors.grey.shade200],
        )!;
    const _edgeInsets = const EdgeInsets.all(6.0);
    return Padding(
      padding: padding ?? const EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius:
            borderRadius ?? const BorderRadius.all(Radius.circular(5)),
        child: Column(
          children: List.generate(rows.length, (index) {
            final _row = rows[index];

            return Container(
              color: _row.bgColor ?? _getRowColor(_rowsGradient, index),
              padding: _row.padding,
              child: Row(
                children: [
                  const Space.h10(),
                  Expanded(
                    flex: _flex.first,
                    child: Padding(
                      padding: _edgeInsets,
                      child: Text(
                        _row.title,
                        textAlign: TextAlign.center,
                        style: _row.titleStyle ??
                            titleStyle ??
                            theme(context).textTheme.titleLarge?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                  ),
                  const SizedBox(
                      height: 20,
                      child: VerticalDivider(
                          color: Colors.white12, thickness: 0.5)),
                  Expanded(
                    flex: _flex.last,
                    child: DefaultTextStyle.merge(
                      style: detailsTextStyle,
                      child: _row.details ??
                          Padding(
                            padding: _edgeInsets,
                            child: Text(
                              replaceFarsiNumber(_row.detailsText ?? "-") ??
                                  "-",
                              textAlign: TextAlign.center,
                              style: _row.detailsStyle ??
                                  GoogleFonts.cairo(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.w400),
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Color? _getRowColor(List<Color> colors, int index) =>
      colors[index % colors.length];
}

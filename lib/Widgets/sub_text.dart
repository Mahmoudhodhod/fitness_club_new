import 'package:flutter/material.dart';

extension SubText on Text {
  ///Returns the same text widget but its data string trimmed to the [max]
  ///giving string length.
  ///
  ///if the max is less than the current givin string length, the original string
  ///is rendered without any modifications or trimming.
  ///
  ///* [max] the max string length after which the string will be trimmed
  ///and appended with three dots (...)
  ///
  ///* [trimEnd] the end of the the trimmed string, defaults to three dots (...)
  Widget subText(int max, [String? trimEnd]) {
    String data = this.data!;
    if (data.length <= max) return this;
    data = data.substring(0, max) + (trimEnd ?? "...");
    return Text(
      data,
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
    );
  }
}

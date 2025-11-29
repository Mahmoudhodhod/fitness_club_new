import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:utilities/utilities.dart';

void main() {
  group("commonOptions()", () {
    test(
      "returns the object modified options when "
      "changing any field.",
      () {
        final ops = Options(
          contentType: "application/json",
        );
        expect(
          commonOptions(ops),
          isA<Options>().having((options) => options.contentType, "contentType", "application/json"),
        );
      },
    );
  });
}

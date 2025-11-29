import 'package:flutter_test/flutter_test.dart';
import 'package:utilities/src/networking.dart';

void main() {
  final testUri = Uri.parse("https://www.google.com");
  const testfragment1 = "/images";
  const testfragment2 = "/my_images";
  const testfragment3 = "/today";

  group("ExtraURi", () {
    group("addSegment()", () {
      test(
        "returns combined [Uri] from two",
        () {
          expect(testUri.addSegment(testfragment1), Uri.parse("https://www.google.com/images"));
        },
      );

      test(
        "returns combined [Uri] from "
        "list of Uri",
        () {
          expect(
            testUri.addSegments([testfragment1, testfragment2, testfragment3]),
            Uri.parse("https://www.google.com/images/my_images/today"),
          );
        },
      );
    });

    group("addQueryParams()", () {
      test(
        "returns [Uri] with given one param",
        () {
          expect(
            testUri.addQueryParams([const QueryParam(param: "q", value: "images_in_July")]),
            Uri.parse("https://www.google.com?q=images_in_July"),
          );
        },
      );

      test(
        "returns [Uri] with given more than one param",
        () {
          expect(
            testUri.addQueryParams([
              const QueryParam(param: "q", value: "images_in_July"),
              const QueryParam(param: "filter", value: "by_history"),
              const QueryParam(param: "size", value: 'high_to_low'),
            ]),
            Uri.parse("https://www.google.com?q=images_in_July&filter=by_history&size=high_to_low"),
          );
        },
      );
    });
  });
}

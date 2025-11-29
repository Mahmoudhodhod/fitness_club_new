import 'package:flutter_test/flutter_test.dart';
import 'package:utilities/utilities.dart';

void main() {
  const Map<String, dynamic> map1 = {
    "name": "Ahmed",
    "age": 21,
  };
  const Map<String, dynamic> map2 = {
    "job": "Software Engineeer",
    "address": "Alex, Egypt",
  };
  const Map<String, dynamic> map3 = {
    "education": "electrical engineering",
  };
  group("mergeMaps()", () {
    test("merges [two] maps into a single one", () {
      expect(mergeMaps([map1, map2]), {
        "name": "Ahmed",
        "age": 21,
        "job": "Software Engineeer",
        "address": "Alex, Egypt",
      });
    });
    test("merges [n] maps into a single one", () {
      expect(mergeMaps([map1, map2, map3]), {
        "name": "Ahmed",
        "age": 21,
        "job": "Software Engineeer",
        "address": "Alex, Egypt",
        "education": "electrical engineering",
      });
    });
  });
}

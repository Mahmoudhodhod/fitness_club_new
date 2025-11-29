///Creates a universal way to localize the search screen to deferent languages.
///
///See also:
///* [ArabicLocalization]
class SearchLocalization {
  const SearchLocalization();

  String get startSearch {
    return "Start search";
  }

  String get errorMessage {
    return "Error happened while searching";
  }

  String get queryNotFound {
    return "No results found";
  }
}

class ArabicLocalization implements SearchLocalization {
  const ArabicLocalization();
  @override
  String get errorMessage => 'حدث خطأ ما اثناء عملية البحث';

  @override
  String get queryNotFound => "لا يوجد نتائج";

  @override
  String get startSearch => "ابدأ بالبحث الان";
}

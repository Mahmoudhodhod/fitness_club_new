import 'package:utilities/utilities.dart';

import './Models/options.dart';

extension DeepLinkOptionsTools on Uri {
  Uri generateDeepLink(DeepLinkOptions options) {
    final jsonData = options.toJson();
    final data = jsonData.keys.map((key) {
      return QueryParam(param: key, value: jsonData[key]);
    }).toList();
    return addQueryParams(data);
  }

  DeepLinkOptions extractDeepLinkOptions() {
    return DeepLinkOptions.fromJson(queryParameters);
  }
}

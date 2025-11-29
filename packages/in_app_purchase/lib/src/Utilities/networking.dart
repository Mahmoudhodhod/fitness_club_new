import 'package:utilities/utilities.dart' show ExtraUri;

Uri _revenueCatBaseUri = Uri.parse('https://api.revenuecat.com/v1');
Uri _subscribersUri = _revenueCatBaseUri.addSegment('/subscribers');

Uri subscriberInfoUri(String id) {
  return _subscribersUri.addSegment('/$id');
}

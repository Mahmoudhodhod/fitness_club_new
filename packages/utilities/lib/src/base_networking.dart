import 'package:utilities/src/networking.dart';

class Network {
  Network._();

  static Uri webSiteUri = Uri.parse("https://el-captain.net/api");
  // static Uri webSiteUri = Uri.parse("https://a0fe-156-211-251-122.eu.ngrok.io/api");
  static Uri clientUri = webSiteUri.addSegment("/client");
  static Uri generalUri = webSiteUri.addSegment("/general");
  static Uri paymentUri = webSiteUri.addSegment("/payment");

  static Uri favoriteUri = clientUri.addSegment("/favorites");
  static Uri likeUri = clientUri.addSegment("/likes");
  static Uri commentsUri = clientUri.addSegment("/comments");
}

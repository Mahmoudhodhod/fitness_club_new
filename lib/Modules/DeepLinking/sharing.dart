import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart';

import 'Models/models.dart';
import '_navigation.dart';
import '_utils.dart';

export 'Models/models.dart';
export '_utils.dart';
export 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class ShareNow {
  const ShareNow._();

  static const String _kDeepLinkPrefix = 'https://elcaptainfit.page.link';

  static Future<Future<ShareResult>> share(DeepLinkOptions options) async {
    final uri = await generateLink(options);
    return Share.share(uri.toString(), subject: options.metadata?['subject']);
  }

  static Future<Uri> generateLink(DeepLinkOptions options) async {
    final dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: _kDeepLinkPrefix,
      link: Uri.parse(_kDeepLinkPrefix).generateDeepLink(options),
      androidParameters: const AndroidParameters(packageName: "io.fitness.club"),
      iosParameters: const IOSParameters(bundleId: "io.fitness.club"),
    );

    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(
      dynamicLinkParams,
      shortLinkType: ShortDynamicLinkType.unguessable,
    );

    return dynamicLink.shortUrl;
  }

  static Future<void> init() {
    _processLink();
    FirebaseDynamicLinks.instance.onLink.listen(handleDeepLinking);
    return Future<void>.value();
  }

  static void _processLink() async {
    // Get any initial links
    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      handleDeepLinking(initialLink);
    }
  }
}

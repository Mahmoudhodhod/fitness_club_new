import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:the_coach/Helpers/cache_manager.dart';

class NetworkImageView extends StatelessWidget {
  /// The target image that is displayed.
  final String url;

  /// How to align the image within its bounds.
  ///
  /// The alignment aligns the given position in the image to the given position
  /// in the layout bounds. For example, a [Alignment] alignment of (-1.0,
  /// -1.0) aligns the image to the top-left corner of its layout bounds, while a
  /// [Alignment] alignment of (1.0, 1.0) aligns the bottom right of the
  /// image with the bottom right corner of its layout bounds. Similarly, an
  /// alignment of (0.0, 1.0) aligns the bottom middle of the image with the
  /// middle of the bottom edge of its layout bounds.
  ///
  /// If the [alignment] is [TextDirection]-dependent (i.e. if it is a
  /// [AlignmentDirectional]), then an ambient [Directionality] widget
  /// must be in scope.
  ///
  /// Defaults to [Alignment.center].
  ///
  /// See also:
  ///
  ///  * [Alignment], a class with convenient constants typically used to
  ///    specify an [AlignmentGeometry].
  ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
  ///    relative to text direction.
  final Alignment? alignment;

  ///If non-null, this color is blended with each image pixel using [colorBlendMode].
  final Color? color;

  ///Rendered images size.
  ///
  ///Defaults to `Size.square(300)`.
  final Size? size;

  ///How to inscribe the image into the space allocated during layout.
  ///
  ///Defaults to `BoxFit.contain`.
  final BoxFit? fit;

  ///The target image's cache key.
  final String? cacheKey;

  final BorderRadius? borderRadius;

  const NetworkImageView({
    Key? key,
    required this.url,
    this.alignment,
    this.color,
    this.size = const Size.square(300),
    this.fit,
    this.cacheKey,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        cacheManager: AppDefaultCacheManager(),
        cacheKey: cacheKey,
        alignment: alignment ?? Alignment.center,
        color: color,
        imageUrl: url,
        fit: fit ?? BoxFit.contain,
        width: size?.width,
        height: size?.height,
        placeholder: (context, _) => const Center(child: CupertinoActivityIndicator()),
        errorWidget: (context, _, __) => const Icon(Icons.error, color: Colors.red),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:the_coach/Helpers/colors.dart';

///Cached circle avatar which displays images and cache them to local storage.
///
class CCircleAvatar extends StatelessWidget {
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

  /// The size of the avatar, expressed as the radius (half the diameter).
  ///
  final double? radius;

  /// The minimum size of the avatar, expressed as the radius (half the
  /// diameter).
  ///
  final double? minRadius;

  /// The maximum size of the avatar, expressed as the radius (half the
  /// diameter).
  ///
  final double? maxRadius;

  ///The target image's cache key.
  final String? cacheKey;

  ///Cached circle avatar which displays images and cach them to local storage.
  ///
  const CCircleAvatar({
    Key? key,
    required this.url,
    this.alignment,
    this.color,
    this.size = const Size.square(300),
    this.fit,
    this.radius,
    this.minRadius,
    this.maxRadius,
    this.cacheKey,
  })  : assert(radius == null || (minRadius == null && maxRadius == null)),
        super(key: key);

  // The default radius if nothing is specified.
  static const double _defaultRadius = 20.0;

  // The default min if only the max is specified.
  static const double _defaultMinRadius = 0.0;

  // The default max if only the min is specified.
  static const double _defaultMaxRadius = double.infinity;

  double get _minDiameter {
    if (radius == null && minRadius == null && maxRadius == null) {
      return _defaultRadius * 2.0;
    }
    return 2.0 * (radius ?? minRadius ?? _defaultMinRadius);
  }

  double get _maxDiameter {
    if (radius == null && minRadius == null && maxRadius == null) {
      return _defaultRadius * 2.0;
    }
    return 2.0 * (radius ?? maxRadius ?? _defaultMaxRadius);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));

    final double minDiameter = _minDiameter;
    final double maxDiameter = _maxDiameter;
    return AnimatedContainer(
      clipBehavior: Clip.antiAlias,
      constraints: BoxConstraints(
        minHeight: minDiameter,
        minWidth: minDiameter,
        maxWidth: maxDiameter,
        maxHeight: maxDiameter,
      ),
      duration: kThemeChangeDuration,
      decoration: BoxDecoration(
        color: CColors.switchable(context, dark: CColors.fancyBlack, light: Colors.grey.shade200),
        shape: BoxShape.circle,
      ),
      child: CachedNetworkImage(
        cacheKey: cacheKey,
        alignment: alignment ?? Alignment.center,
        color: color,
        imageUrl: url,
        fit: fit ?? BoxFit.contain,
        width: size?.width,
        height: size?.height,
        placeholder: (context, _) => const Center(child: CupertinoActivityIndicator()),
        errorWidget: (context, _, error) {
          return Icon(Icons.image_not_supported, color: CColors.primary(context));
        },
      ),
    );
  }
}

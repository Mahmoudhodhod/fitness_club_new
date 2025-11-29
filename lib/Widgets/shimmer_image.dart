import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class ShimmerImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit? boxFit;
  final double? width;
  final double? height;
  final Alignment? alignment;
  final String? cacheKey;

  const ShimmerImage({
    Key? key,
    required this.imageUrl,
    this.boxFit,
    this.width,
    this.height,
    this.alignment,
    this.cacheKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FancyShimmerImage(
      // cacheManager: AppDefaultCacheManager(),
      cacheKey: cacheKey,
      imageUrl: imageUrl,
      boxFit: boxFit ?? BoxFit.cover,
      height: height ?? 100,
      width: width ?? 100,
      alignment: alignment,
    );
  }
}

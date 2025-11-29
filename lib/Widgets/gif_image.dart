// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui';

// // ignore: implementation_imports
// import 'package:cached_network_image/src/image_provider/cached_network_image_provider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// import 'package:http/http.dart' as http;

// // copied from: https://pub.dev/packages/gif_view

// final Map<String, List<ImageInfo>> _cache = {};

// class GifView extends StatefulWidget {
//   final int frameRate;
//   final VoidCallback? onFinish;
//   final VoidCallback? onStart;
//   final ValueChanged<int>? onFrame;
//   final ImageProvider image;
//   final bool loop;
//   final double? height;
//   final double? width;
//   final Widget? progress;
//   final BoxFit? fit;
//   final Color? color;
//   final BlendMode? colorBlendMode;
//   final AlignmentGeometry alignment;
//   final ImageRepeat repeat;
//   final Rect? centerSlice;
//   final bool matchTextDirection;
//   final bool invertColors;
//   final FilterQuality filterQuality;
//   final bool isAntiAlias;

//   GifView.network(
//     String url, {
//     Key? key,
//     this.frameRate = 15,
//     this.loop = true,
//     this.height,
//     this.width,
//     this.progress,
//     this.fit,
//     this.color,
//     this.colorBlendMode,
//     this.alignment = Alignment.center,
//     this.repeat = ImageRepeat.noRepeat,
//     this.centerSlice,
//     this.matchTextDirection = false,
//     this.invertColors = false,
//     this.filterQuality = FilterQuality.low,
//     this.isAntiAlias = false,
//     this.onFinish,
//     this.onStart,
//     this.onFrame,
//   })  : image = NetworkImage(url),
//         super(key: key);

//   GifView.networkCached(
//     String url, {
//     Key? key,
//     this.frameRate = 15,
//     this.loop = true,
//     this.height,
//     this.width,
//     this.progress,
//     this.fit,
//     this.color,
//     this.colorBlendMode,
//     this.alignment = Alignment.center,
//     this.repeat = ImageRepeat.noRepeat,
//     this.centerSlice,
//     this.matchTextDirection = false,
//     this.invertColors = false,
//     this.filterQuality = FilterQuality.low,
//     this.isAntiAlias = false,
//     this.onFinish,
//     this.onStart,
//     this.onFrame,
//   })  : image = CachedNetworkImageProvider(url),
//         super(key: key);

//   GifView.asset(
//     String asset, {
//     Key? key,
//     this.frameRate = 15,
//     this.loop = true,
//     this.height,
//     this.width,
//     this.progress,
//     this.fit,
//     this.color,
//     this.colorBlendMode,
//     this.alignment = Alignment.center,
//     this.repeat = ImageRepeat.noRepeat,
//     this.centerSlice,
//     this.matchTextDirection = false,
//     this.invertColors = false,
//     this.filterQuality = FilterQuality.low,
//     this.isAntiAlias = false,
//     this.onFinish,
//     this.onStart,
//     this.onFrame,
//   })  : image = AssetImage(asset),
//         super(key: key);

//   GifView.memory(
//     Uint8List bytes, {
//     Key? key,
//     this.frameRate = 15,
//     this.loop = true,
//     this.height,
//     this.width,
//     this.progress,
//     this.fit,
//     this.color,
//     this.colorBlendMode,
//     this.alignment = Alignment.center,
//     this.repeat = ImageRepeat.noRepeat,
//     this.centerSlice,
//     this.matchTextDirection = false,
//     this.invertColors = false,
//     this.filterQuality = FilterQuality.low,
//     this.isAntiAlias = false,
//     this.onFinish,
//     this.onStart,
//     this.onFrame,
//   })  : image = MemoryImage(bytes),
//         super(key: key);

//   const GifView({
//     Key? key,
//     this.frameRate = 15,
//     required this.image,
//     this.loop = true,
//     this.height,
//     this.width,
//     this.progress,
//     this.fit,
//     this.color,
//     this.colorBlendMode,
//     this.alignment = Alignment.center,
//     this.repeat = ImageRepeat.noRepeat,
//     this.centerSlice,
//     this.matchTextDirection = false,
//     this.invertColors = false,
//     this.filterQuality = FilterQuality.low,
//     this.isAntiAlias = false,
//     this.onFinish,
//     this.onStart,
//     this.onFrame,
//   }) : super(key: key);

//   @override
//   _GifViewState createState() => _GifViewState();
// }

// class _GifViewState extends State<GifView> with TickerProviderStateMixin {
//   List<ImageInfo> frames = [];
//   int currentIndex = 0;
//   AnimationController? _controller;
//   Tween<int> tweenFrames = Tween();

//   @override
//   void initState() {
//     Future.delayed(Duration.zero, _loadImage);
//     super.initState();
//   }

//   ImageInfo get currentFrame => frames[currentIndex];

//   @override
//   Widget build(BuildContext context) {
//     if (frames.isEmpty) {
//       return SizedBox(
//         width: widget.width,
//         height: widget.height,
//         child: widget.progress ?? const CupertinoActivityIndicator(),
//       );
//     }
//     return RawImage(
//       image: currentFrame.image,
//       width: widget.width,
//       height: widget.height,
//       scale: currentFrame.scale,
//       fit: widget.fit,
//       color: widget.color,
//       colorBlendMode: widget.colorBlendMode,
//       alignment: widget.alignment,
//       repeat: widget.repeat,
//       centerSlice: widget.centerSlice,
//       matchTextDirection: widget.matchTextDirection,
//       invertColors: widget.invertColors,
//       filterQuality: widget.filterQuality,
//       isAntiAlias: widget.isAntiAlias,
//     );
//   }

//   final HttpClient _sharedHttpClient = HttpClient()..autoUncompress = false;

//   HttpClient get _httpClient {
//     HttpClient client = _sharedHttpClient;
//     assert(() {
//       if (debugNetworkImageHttpClientProvider != null) {
//         client = debugNetworkImageHttpClientProvider!();
//       }
//       return true;
//     }());
//     return client;
//   }

//   String _getKeyImage(ImageProvider provider) {
//     return provider is CachedNetworkImageProvider
//         ? provider.url
//         : provider is NetworkImage
//             ? provider.url
//             : provider is AssetImage
//                 ? provider.assetName
//                 : provider is MemoryImage
//                     ? provider.bytes.toString()
//                     : "";
//   }

//   Future<List<ImageInfo>> fetchGif(ImageProvider provider) async {
//     List<ImageInfo> frameList = [];
//     dynamic data;
//     String key = _getKeyImage(provider);
//     if (_cache.containsKey(key)) {
//       frameList = _cache[key]!;
//       return frameList;
//     }
//     if (provider is NetworkImage) {
//       data = _downloadAndCacheNetworkImage(provider.url);
//     } else if (provider is AssetImage) {
//       AssetBundleImageKey key = await provider.obtainKey(const ImageConfiguration());
//       data = await key.bundle.load(key.name);
//     } else if (provider is FileImage) {
//       data = await provider.file.readAsBytes();
//     } else if (provider is MemoryImage) {
//       data = provider.bytes;
//     }

//     Codec? codec = await PaintingBinding.instance?.instantiateImageCodec(data.buffer.asUint8List());

//     if (codec != null) {
//       for (int i = 0; i < codec.frameCount; i++) {
//         FrameInfo frameInfo = await codec.getNextFrame();
//         //scale ??
//         frameList.add(ImageInfo(image: frameInfo.image));
//       }
//       _cache.putIfAbsent(key, () => frameList);
//     }
//     return frameList;
//   }

//   FutureOr _loadImage() async {
//     frames = await fetchGif(widget.image);
//     if (widget.frameRate < 1) {
//       return setState(() => currentIndex = 1);
//     }
//     tweenFrames = IntTween(begin: 0, end: frames.length - 1);
//     int milli = ((frames.length / widget.frameRate) * 1000).ceil();
//     Duration duration = Duration(
//       milliseconds: milli,
//     );
//     _controller = AnimationController(vsync: this, duration: duration);
//     _controller?.addListener(_listener);
//     widget.onStart?.call();
//     _controller?.forward(from: 0.0);
//   }

//   void _listener() {
//     int newFrame = tweenFrames.transform(_controller!.value);
//     if (currentIndex != newFrame) {
//       if (mounted) {
//         setState(() {
//           currentIndex = newFrame;
//         });
//         widget.onFrame?.call(newFrame);
//       }
//     }
//     if (_controller?.status == AnimationStatus.completed) {
//       widget.onFinish?.call();
//       if (widget.loop) {
//         _controller?.forward(from: 0.0);
//       }
//     }
//   }

//   Future<Uint8List> _downloadAndCacheNetworkImage(String url) async {
//     final cachManager = DefaultCacheManager();
//     final fileInfo = await cachManager.getFileFromCache(url);
//     if (fileInfo == null) {
//       final Uri resolved = Uri.base.resolve(url);
//       final response = await http.get(resolved);
//       final dataAsBytes = response.bodyBytes;
//       await cachManager.putFile(
//         url,
//         dataAsBytes,
//         eTag: url,
//         fileExtension: 'gif',
//         maxAge: Duration(days: 40),
//       );
//       return dataAsBytes;
//     }
//     await cachManager.dispose();
//     return fileInfo.file.readAsBytes();
//   }

//   @override
//   void dispose() {
//     _controller?.removeListener(_listener);
//     _controller?.dispose();
//     super.dispose();
//   }
// }

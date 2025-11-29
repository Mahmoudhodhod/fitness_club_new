import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:the_coach/Helpers/cache_manager.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Screens/Helpers/shelpers.dart';
import 'package:the_coach/Widgets/widgets.dart';

///Displays images in a slide view with an indicator.
///
///Use `SlideShow().show(BuildContext)` to display the slider.
///
class SlideShow extends StatefulWidget {
  ///Slide show initial displayed image index, defaults to `0`.
  ///
  final int initialIndex;

  ///Displayed images.
  ///
  ///this Property must not be null.
  final List<ImageProvider> images;

  ///Displays images in a slide view with an indicator.
  ///
  const SlideShow({
    Key? key,
    this.initialIndex = 0,
    required this.images,
  }) : super(key: key);

  ///Displays the current image slider.
  ///
  Future<void> show(BuildContext context) async {
    return Navigator.of(context, rootNavigator: true).push<void>(
      FadePageRoute(
          duration: Duration(milliseconds: 100), builder: (_) => this),
    );
  }

  @override
  _SlideShowState createState() => _SlideShowState();
}

class _SlideShowState extends State<SlideShow> {
  late List<ImageProvider> _images;
  late final PageController _pageController;
  late final ValueNotifier<int> _currentPage;

  @override
  void initState() {
    _images = widget.images;
    _currentPage = ValueNotifier(widget.initialIndex);
    _pageController = PageController(initialPage: widget.initialIndex)
      ..addListener(() => _currentPage.value = _pageController.page!.round());
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: PhotoViewGallery.builder(
                itemCount: _images.length,
                pageController: _pageController,
                loadingBuilder: (context, event) => const PaginationLoader(),
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: _buildImageProvider(index),
                    initialScale: PhotoViewComputedScale.contained,
                  );
                },
              ),
            ),
            Align(
              alignment: AlignmentDirectional(-0.9, -0.9),
              child: GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: BackButton(),
                ),
              ),
            ),
            if (_images.length > 1)
              Align(
                alignment: Alignment(0, 0.9),
                child: ValueListenableBuilder<int>(
                  valueListenable: _currentPage,
                  builder: (context, value, child) {
                    return PageViewDotIndicator(
                      currentItem: value,
                      count: _images.length,
                      unselectedColor: CColors.fancyBlack,
                      selectedColor: CColors.secondary(context),
                      size: Size.square(18),
                    );
                  },
                ),
              )
          ],
        ),
      ),
    );
  }

  ImageProvider<Object> _buildImageProvider(int index) {
    final _imageProvider = _images[index];
    if (_imageProvider is NetworkImage) {
      return CachedNetworkImageProvider(
        _imageProvider.url,
        cacheManager: AppDefaultCacheManager(),
      );
    }
    return _imageProvider;
  }
}

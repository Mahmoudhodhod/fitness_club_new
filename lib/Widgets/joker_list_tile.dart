import 'package:flutter/material.dart';
import 'package:the_coach/Helpers/colors.dart';

import 'package:utilities/utilities.dart';
import 'package:the_coach/Widgets/widgets.dart';

///The [JokerListTile] title position which determine the title position on the list tile.
enum TitlePosition {
  center,
  bottomShadowed,
  highlighted,
}

///A custom and amazing list tile to use all over the app.
///
class JokerListTile extends StatelessWidget {
  /// The primary content of the list tile.
  final String? titleText;

  ///Title text style, defaults to `subtitle1` with size of `19`.
  final TextStyle? titleStyle;

  ///The primary title widget, its position is determined by `TitlePosition`.
  ///
  final Widget? title;

  ///the image path of the main image which will be displayed as a background image.
  ///
  final String? imagePath;

  ///loaded background image alignment.
  final Alignment? imageAlignment;

  /// A tap with a primary button has occurred.
  ///
  final VoidCallback? onTap;

  ///The user has tapped the screen with a primary button at the same location twice in quick succession.
  ///See also:
  /// [kPrimaryButton], the button this callback responds to.
  ///
  final VoidCallback? onDoubleTap;

  /// Called when a long press gesture with a primary button has been recognized.
  ///
  /// Triggered when a pointer has remained in contact with the screen at the
  /// same location for a long period of time.
  ///
  /// This is equivalent to (and is called immediately after) [onLongPressStart].
  /// The only difference between the two is that this callback does not
  /// contain details of the position at which the pointer initially contacted
  /// the screen.
  final VoidCallback? onLongPress;

  /// A widget to display before the title.
  ///
  /// Typically an [Icon] or a [CircleAvatar] widget.
  final Widget? leading;

  /// A widget to display after the title.
  ///
  /// Typically an [Icon] widget.
  ///
  final Widget? trailing;

  ///The title position on the list tile, defaults to `TitlePosition.highlighted`.
  final TitlePosition titlePosition;

  ///Tile's border radius.
  final BorderRadius borderRadius;

  /// The tile's internal padding.
  ///
  /// Insets a [ListTile]'s contents: its [leading] and [trailing] widgets.
  ///
  /// If null, `const EdgeInsets.symmetric(horizontal: 5, vertical: 10)` is used.
  final EdgeInsetsGeometry contentPadding;

  ///the estimated height of the tile, defaults to `0.22 * screen.width`.
  ///
  final double? estimatedHeight;

  ///When setting `titlePosition` to be `TitlePosition.bottomShadowed` (its default value BTW),
  ///this will be the drop shadow behind the title.
  ///
  ///Defaults to `100.0`.
  final double? titleShadowHeight;

  ///A custom and amazing list tile to use all over the app.
  ///
  const JokerListTile({
    Key? key,
    this.titleText,
    this.title,
    this.imagePath,
    this.onTap,
    this.leading,
    this.trailing,
    this.titlePosition = TitlePosition.highlighted,
    this.borderRadius = const BorderRadius.all(Radius.circular(5.0)),
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    this.estimatedHeight,
    this.titleShadowHeight,
    this.titleStyle,
    this.onDoubleTap,
    this.onLongPress,
    this.imageAlignment,
  })  : assert(
          title == null || titleText == null,
          "You should use [titleText] or [title] not both.",
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _vPadding = contentPadding.vertical;
    final double _hPadding = contentPadding.horizontal;

    return SizedBox(
      height: estimatedHeight ?? screenSize.height * 0.22,
      child: GestureDetector(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          color: Colors.black45,
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: borderRadius,
                  child: _buildImagePreview(),
                ),
              ),
              if (titlePosition == TitlePosition.bottomShadowed)
                GradientShadower.stacked(
                  border: borderRadius,
                  height: titleShadowHeight,
                ),
              _buildTitle(context),
              PositionedDirectional(
                start: _hPadding,
                top: _vPadding,
                child: Container(child: leading),
              ),
              PositionedDirectional(
                end: _hPadding,
                top: _vPadding,
                bottom: _vPadding,
                child: Container(child: trailing),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final _title = title ??
        Text(
          titleText ?? "-",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: CColors.nullableSwitchable(context, light: Colors.white),
              ),
          textAlign: TextAlign.center,
        );

    switch (titlePosition) {
      case TitlePosition.center:
        return Center(child: _title);
      case TitlePosition.bottomShadowed:
        return Align(alignment: const Alignment(0, 0.7), child: _title);
      case TitlePosition.highlighted:
        return Align(
          alignment: const Alignment(0, 0.93),
          child: Padding(
            padding: KEdgeInsets.h10,
            child: Card(
              color: CColors.switchable(
                context,
                dark: Colors.black45,
                light: Colors.white38,
              ),
              shape: const RoundedRectangleBorder(borderRadius: KBorders.bc5),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: _title,
              ),
            ),
          ),
        );
      default:
        return _title;
    }
  }

  Widget _buildImagePreview() {
    if (imagePath == null) {
      return const SizedBox.shrink();
    }
    final isGIF = imagePath!.contains('.gif');
    if (isGIF) {
      return NetworkImageView(
        url: imagePath!,
        fit: BoxFit.cover,
      );
    }
    return ShimmerImage(
      imageUrl: imagePath!,
      boxFit: BoxFit.cover,
    );
  }
}

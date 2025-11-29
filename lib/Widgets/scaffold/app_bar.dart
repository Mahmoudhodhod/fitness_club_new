import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_coach/Helpers/colors.dart';

///Custom appbar which wraps the original native [AppBar] widget.
///
class CAppBar extends StatelessWidget implements PreferredSizeWidget {
  ///Center AppBar header.
  final String? header;

  ///Center custom AppBar header widget.
  final Widget? headerWidget;

  ///Leading widget.
  ///
  ///if `Arabic` it will be at the right side of the appbar.
  final Widget? leading;

  ///AppBar actions.
  ///
  ///if `Arabic` it will be at the left side of the appbar
  final List<Widget>? actions;

  ///Appbar brightness, and defaults to the system's theme brightness.
  final Brightness? brightness;

  ///Bacegound color of [AppBar], defaults to `Colors.transparent`.
  final Color? bgColor;

  ///The elevalion of the [AppBar], defaults to `0.0`.
  final double? elevation;

  ///Returns [SliverAppBar] instead of [AppBar] to use in [CustomScrollView], defaults to: `false`.
  final bool isSliver;

  ///[CAppBar] sliver styling.
  ///
  ///Settings this property as non-null converts [CAppBar] to a Sliver widget.
  final SliverStyle? sliverStyle;

  /// Defines the width of [leading] widget.
  ///
  /// By default, the value of `leadingWidth` is 56.0.
  final double? leadingWidth;

  ///Custom appbar which wraps the original native [AppBar] widget.
  ///
  const CAppBar({
    Key? key,
    this.header,
    this.headerWidget,
    this.leading,
    this.actions,
    this.brightness,
    this.bgColor,
    this.elevation,
    @Deprecated(
        "By setting [sliverStyle] as non null value you tell Flutter to render the [sliver] version of the widget")
    this.isSliver = false,
    this.sliverStyle,
    this.leadingWidth,
  })  : assert(header == null || headerWidget == null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _sliverStyle = SliverStyle().merge(other: sliverStyle);

    if (sliverStyle != null || isSliver) {
      return SliverAppBar(
        key: const Key("global_sliver_appbar"),
        elevation: elevation,
        backgroundColor: bgColor,
        title: _buildHeader(context),
        actions: actions,
        leading: leading,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: brightness),
        centerTitle: true,
        snap: _sliverStyle.snap ?? true,
        floating: _sliverStyle.floating ?? true,
        pinned: _sliverStyle.pinned ?? true,
        leadingWidth: leadingWidth,
      );
    }
    return AppBar(
      key: const Key("global_appbar"),
      elevation: 0.0,
      backgroundColor: bgColor,
      title: _buildHeader(context),
      actions: actions,
      leading: leading,
      systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: brightness),
      centerTitle: true,
      leadingWidth: leadingWidth,
    );
  }

  Widget _buildHeader(BuildContext context) {
    final child = header == null ? headerWidget : Text(header!);
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: CColors.nullableSwitchable(
                  context,
                  light: Colors.white,
                ),
                fontWeight: FontWeight.bold,
              ) ??
          const TextStyle(),
      child: child ?? const SizedBox.shrink(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

///Iconbutton which opens the drawer in scaffold if any found.
class DrawerIconButton extends StatelessWidget {
  const DrawerIconButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      },
    );
  }
}

///[CAppBar] sliver style.
///
class SliverStyle {
  ///If [snap] and [floating] are true then the floating app bar will "snap" into view.
  final bool? snap;

  /// Whether the app bar should become visible as soon as the user scrolls
  /// towards the app bar.
  ///
  /// Otherwise, the user will need to scroll near the top of the scroll view to
  /// reveal the app bar.
  ///
  final bool? floating;

  /// Whether the app bar should remain visible at the start of the scroll view.
  ///
  /// The app bar can still expand and contract as the user scrolls, but it will
  /// remain visible rather than being scrolled out of view.
  final bool? pinned;

  const SliverStyle({
    this.snap = true,
    this.floating = true,
    this.pinned = false,
  });

  SliverStyle copyWith({
    bool? snap,
    bool? floating,
    bool? pinned,
  }) {
    return SliverStyle(
      snap: snap ?? this.snap,
      floating: floating ?? this.floating,
      pinned: pinned ?? this.pinned,
    );
  }

  SliverStyle merge({SliverStyle? other}) {
    if (other == null) return this;
    return copyWith(
      floating: other.floating,
      pinned: other.pinned,
      snap: other.snap,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SliverStyle &&
        other.snap == snap &&
        other.floating == floating &&
        other.pinned == pinned;
  }

  @override
  int get hashCode => snap.hashCode ^ floating.hashCode ^ pinned.hashCode;
}

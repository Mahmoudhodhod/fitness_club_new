import 'package:flutter/material.dart';

import 'package:utilities/utilities.dart';
import 'package:the_coach/Widgets/widgets.dart';

///shows a custom sheet from the bottom.
///
///the sheet has a title and a body properties
///
/// The `useRootNavigator` parameter ensures that the root navigator is used to
/// display the [BottomSheet] when set to `true`. This is useful in the case
/// that a modal [BottomSheet] needs to be displayed above all other content
/// but the caller is inside another [Navigator].
///
///See also:
///* [ButtomSheetDelegate]: Sheet delegate which has all the widgets required to style and fill the sheet.
///* [ListDelegate]: A delegate that supplies children for slivers using a builder callback and a separator builder.
@Deprecated("use `CustomButtomSheet().show()` instead")
Future<void> showCustomBottomSheet(
  BuildContext context, {
  required BottomSheetDelegate delegate,
  bool useRootNavigator = false,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    barrierColor: Colors.black87,
    useRootNavigator: useRootNavigator,
    shape: RoundedRectangleBorder(
      borderRadius: delegate.borderRadius ??
          const BorderRadius.vertical(
            top: const Radius.circular(20.0),
          ),
    ),
    builder: (_) => CustomBottomSheet(
      delegate: delegate,
    ),
  );
}

///the bottom sheet delegate which has all the widgets required to style and fill the sheet.
///
class BottomSheetDelegate {
  ///it is the main part of the widget which contains all the widget in the widget's body.
  ///
  ///Note: if you want to use a [ListView] in the body the [BottomSheetDelegate] has a very useful propety
  ///which will help.
  ///
  final Widget? body;

  ///the button sheet title text.
  ///
  ///it is showen at the sheet's topCenter section.
  ///
  ///if you want more customized header section use [header]
  final String? title;

  ///[title] text style.
  final TextStyle? titleStyle;

  ///the header widget, which is rendered at the top center section of the sheet.
  ///
  ///if you want to use just a [title] text use the propety [title].
  ///
  final Widget? header;

  ///the height fracion of the sheet relative to the screen height.
  final double? heightFraction;

  ///sheet border radius, defaults to: `BorderRadius.vertical(top: const Radius.circular(20.0))`
  final BorderRadiusGeometry? borderRadius;

  ///sheet list delegate which is used to build a body section more like a [ListView].
  ///
  final ListDelegate? listDelegate;

  ///the bottom sheet delegate which has all the widgets required to style and fill the sheet.
  ///
  const BottomSheetDelegate({
    this.body,
    this.title,
    this.titleStyle,
    this.header,
    this.heightFraction,
    this.borderRadius,
    this.listDelegate,
  }) : assert(header == null || title == null, "You must use [header] or [title] not both.");
}

/// a custom widget which can be loaded with a list of items to perform some operation on it,
/// like displaying a list of fruits.
///
class CustomBottomSheet extends StatelessWidget {
  final BottomSheetDelegate? delegate;

  /// a custom widget which can be loaded with a list of items to perform some operation on it,
  /// like displaying a list of fruits.
  ///
  const CustomBottomSheet({
    Key? key,
    this.delegate,
  }) : super(key: key);

  ///shows a custom sheet from the bottom.
  ///
  ///the sheet has a title and a body properties
  ///
  /// The `useRootNavigator` parameter ensures that the root navigator is used to
  /// display the [BottomSheet] when set to `true`. This is useful in the case
  /// that a modal [BottomSheet] needs to be displayed above all other content
  /// but the caller is inside another [Navigator].
  ///
  ///See also:
  ///* [ButtomSheetDelegate]: Sheet delegate which has all the widgets required to style and fill the sheet.
  ///* [ListDelegate]: A delegate that supplies children for slivers using a builder callback and a separator builder.
  Future<void> show(BuildContext context, {bool useRootNavigator = false}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.black87,
      useRootNavigator: useRootNavigator,
      shape: RoundedRectangleBorder(
        borderRadius: this.delegate?.borderRadius ??
            const BorderRadius.vertical(
              top: const Radius.circular(20.0),
            ),
      ),
      builder: (_) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double? _sheetHeight = screenSize.height * (delegate?.heightFraction ?? 0.8);
    //if a list delegate is not supplied make the height reponsive.
    if (delegate?.listDelegate == null) _sheetHeight = null;
    return Container(
      // height: _sheetHeight,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Space.v10(),
            Stack(
              alignment: Alignment.center,
              children: [
                if (delegate?.header == null) ...[
                  Center(
                    child: Padding(
                      padding: KEdgeInsets.h20,
                      child: Text(
                        delegate?.title ?? "",
                        key: const Key("pre_built_title"),
                        textAlign: TextAlign.center,
                        style: delegate?.titleStyle,
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: CloseButton(),
                  ),
                ] else if (delegate?.header != null) ...[
                  delegate!.header!
                ] else
                  const SizedBox(),
              ],
            ),
            _buildBody()
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (delegate?.body != null) return delegate!.body!;
    if (delegate?.listDelegate != null) {
      final style = delegate!.listDelegate!;
      return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        key: const Key("list"),
        padding: style.padding,
        separatorBuilder: style.separatorBuilder ?? (_, __) => const SizedBox.shrink(),
        itemCount: style.itemCount,
        itemBuilder: style.builder,
      );
    }
    return const SizedBox(key: const Key("place_holder_box"));
  }
}

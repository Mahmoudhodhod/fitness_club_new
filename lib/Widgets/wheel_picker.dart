import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:utilities/utilities.dart';
import 'package:the_coach/Widgets/widgets.dart';

///A very simple but power full tool to use when you need to construct a multiselect
///picker, ex: when the user chooses his country from a list, the list would be very nice when
///it is impelemented in a wheel like picker and very easy to orgnize your list of data, too.
///
///use `WheelPicker().show()` to display the wheel picker as a [ModalBottomSheet].
///
class WheelPicker extends StatefulWidget {
  /// A [FixedExtentScrollController] to read and control the current item, and
  /// to set the initial item.
  ///
  /// If null, an implicit one will be created internally.
  final FixedExtentScrollController? controller;

  ///The list delegate which we use here to construct our widget's list and display
  ///to the user.
  final ListDelegate delegate;

  ///Initial item index, very usful when you want to go a head and pick a default
  ///value for the user, defaults to `0`
  ///
  ///has no effect when supplying a controller to [WheelPicker].
  final int initialIndex;

  ///Triggerd when the user changes his selection from the picker.
  ///
  ///Returns with the current selected item index.
  final ValueChanged<int>? onChanged;

  ///Debounces the [onChanged] method call.
  final TimeDebouncer? timeDebouncer;

  /// The uniform height of all children.
  ///
  /// All children will be given the [BoxConstraints] to match this exact
  /// height. Must not be null and must be positive.
  final double? itemExtent;

  ///Constructs [WheelPicker] with list delegate and an optional initial value.
  ///
  ///use [this.show()] to display it.
  ///
  const WheelPicker({
    Key? key,
    required this.delegate,
    this.controller,
    this.initialIndex = 0,
    this.onChanged,
    this.timeDebouncer,
    this.itemExtent,
  }) : super(key: key);

  ///Displays [WheelPicker] as a [ModalBottomSheet].
  ///
  ///current `context` must be valid.
  Future<void> show(BuildContext context, {bool useRootNavigator = false}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: useRootNavigator,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: const Radius.circular(15)),
      ),
      builder: (_) => this,
    );
  }

  @override
  WheelPickerState createState() => WheelPickerState();
}

class WheelPickerState extends State<WheelPicker> {
  late ListDelegate _delegate;
  FixedExtentScrollController? _scrollController;

  @override
  void initState() {
    _delegate = widget.delegate;

    _scrollController = widget.controller ??
        FixedExtentScrollController(
          initialItem: widget.initialIndex,
        );

    _scrollController!.addListener(() {
      widget.timeDebouncer?.add(_scrollController!.selectedItem);
    });

    super.initState();
  }

  @override
  void didUpdateWidget(covariant WheelPicker oldWidget) {
    if (oldWidget.delegate != widget.delegate) {
      setState(() => _delegate = widget.delegate);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    widget.timeDebouncer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenSize.height * 0.25,
      decoration: BoxDecoration(
        color: appTheme.scaffoldBackgroundColor,
        borderRadius: KBorders.bc5,
      ),
      child: ClipRRect(
        borderRadius: KBorders.bc5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 5),
            Card(
              color: Colors.grey[350],
              margin: EdgeInsets.only(top: 5),
              elevation: 0.0,
              shape: RoundedRectangleBorder(borderRadius: KBorders.bc5),
              child: const SizedBox(width: 60, height: 7),
            ),
            Expanded(
              child: CupertinoPicker.builder(
                key: const Key("picker"),
                scrollController: _scrollController,
                backgroundColor: appTheme.scaffoldBackgroundColor,
                // magnification: 10,
                // useMagnifier: true,
                itemExtent: widget.itemExtent ?? 35,
                onSelectedItemChanged: widget.onChanged,
                childCount: _delegate.itemCount,
                itemBuilder: _delegate.builder,
              ),
            )
          ],
        ),
      ),
    );
  }
}

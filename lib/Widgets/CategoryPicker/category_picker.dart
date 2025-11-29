import 'package:easy_localization/easy_localization.dart';
import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Helpers/logger.dart';
import 'package:utilities/utilities.dart';

import 'category_picker_item.dart';
import 'package:flutter/material.dart';

export 'category_picker_item.dart';

typedef IndexedValueChanged<T> = void Function(
    CategoryPickerItem<T> value, int index);

/// An input widget to handle selection of category like choices.
///
/// Inspired by the YouTube recommendations bar on the home page
class CategoryPicker<T> extends StatefulWidget {
  /// An input widget to handle selection of category like choices.
  ///
  /// Inspired by the YouTube recommendations bar on the home page
  const CategoryPicker({
    required this.items,
    this.initialItem = 0,
    this.onChanged,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor = Colors.transparent,
    this.selectedItemBorderColor = Colors.transparent,
    this.unselectedItemBorderColor,
    this.selectedItemTextDarkThemeColor,
    this.selectedItemTextLightThemeColor,
    this.unselectedItemTextDarkThemeColor,
    this.unselectedItemTextLightThemeColor,
    this.itemBorderRadius,
    this.itemHeight = 32.0,
    this.itemLabelFontSize,
    this.categoryPickerMargin = const EdgeInsets.symmetric(vertical: 11),
    this.categoryPickerPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.itemMargin = const EdgeInsets.symmetric(horizontal: 4),
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 12),
  });

  /// List of children to be displayed
  ///
  /// Only required parameter
  final List<CategoryPickerItem<T>> items;

  /// Default selected item in range of `0` - `items.length`
  ///
  /// Defaults to `0`
  final int initialItem;

  /// Callback with entire item when user switches selection.
  ///
  /// Value of item can be accessed with `value.value`.
  final IndexedValueChanged<T>? onChanged;

  /// Background color of entire category picker
  ///
  /// Defaults to `Colors.transparent`
  final Color? backgroundColor;

  /// Background color of selected item
  ///
  /// Defaults to `Theme.of(context).accentColor`
  final Color? selectedItemColor;

  /// Background color of all items that are not selected
  ///
  /// Defaults to `Colors.transparent`
  final Color? unselectedItemColor;

  /// Border color of the selected item
  ///
  /// Defaults to `Colors.transparent`
  final Color? selectedItemBorderColor;

  /// Border color of all unselected items
  ///
  /// Defaults to `Colors.grey[800]`
  final Color? unselectedItemBorderColor;

  /// Text color of the text for light theme inside an item while selected
  ///
  /// Defaults to `Colors.white`
  final Color? selectedItemTextLightThemeColor;

  /// Text color of the text for light theme inside an item while not selected
  ///
  /// Defaults to `Colors.black`
  final Color? unselectedItemTextLightThemeColor;

  /// Text color of the text for dark theme inside an item while selected
  ///
  /// Defaults to `Colors.white`
  final Color? selectedItemTextDarkThemeColor;

  /// Text color of the text for dark theme inside an item while not selected
  ///
  /// Defaults to `Colors.white`
  final Color? unselectedItemTextDarkThemeColor;

  /// Border radius for all items
  ///
  /// Defaults to `BorderRadius.circular(30)`
  final BorderRadius? itemBorderRadius;

  /// Height of all items
  ///
  /// Defaults to `32.0`
  final double itemHeight;

  /// Font size of the text inside of all items
  ///
  /// Defaults to `theme(context).textTheme.subtitle2.fontSize`
  final double? itemLabelFontSize;

  /// Padding of the entire category picker
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 16)`
  final EdgeInsetsGeometry categoryPickerPadding;

  /// Margin of the entire category picker
  ///
  /// Defaults to `EdgeInsets.symmetric(vertical: 11)`
  final EdgeInsetsGeometry categoryPickerMargin;

  /// Padding applied to each individual item
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 12)`
  final EdgeInsetsGeometry itemPadding;

  /// Margin applied to each individual item
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 4)`
  final EdgeInsetsGeometry itemMargin;

  @override
  _CategoryPickerState<T> createState() => _CategoryPickerState<T>();
}

class _CategoryPickerState<T> extends State<CategoryPicker<T>> {
  late final ScrollController _scrollController;
  late List<CategoryPickerItem<T>> _items;
  late CategoryPickerItem<T>? _value;
  late int _selectedIndex;

  @override
  void initState() {
    _scrollController = ScrollController();
    _items = widget.items;
    _selectedIndex = widget.initialItem;
    _value = _items[_selectedIndex];
    _items[_selectedIndex].isSelected = true;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CategoryPicker<T> oldWidget) {
    if (oldWidget.items != widget.items) {
      setState(() {
        _items = widget.items;

        if (_selectedIndex >= _items.length)
          _selectedIndex = widget.initialItem;
        _value = _items[_selectedIndex];
        _items[_selectedIndex].isSelected = true;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          margin: widget.categoryPickerMargin,
          color: widget.backgroundColor ?? Colors.transparent,
          child: Container(
            height: widget.itemHeight,
            child: ListView.builder(
              padding: widget.categoryPickerPadding,
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: _items.length,
              itemBuilder: (context, index) {
                var isDark = Theme.of(context).brightness == Brightness.light;
                var selected = _items[index].isSelected;
                return GestureDetector(
                  onTap: () async {
                    if (_selectedIndex == index) return;
                    setState(() {
                      _items[0].isSelected = false;
                      if (_value != null) {
                        _value!.isSelected = false;
                      }
                      _items[index].isSelected = !selected;
                      _value = _items[index];
                    });
                    _selectedIndex = index;
                    widget.onChanged?.call(_value!, index);
                  },
                  child: Container(
                    margin: widget.itemMargin,
                    padding: widget.itemPadding,
                    decoration: BoxDecoration(
                      border: _border(index),
                      color: selected
                          // ignore: deprecated_member_use
                          ? widget.selectedItemColor ??
                              Theme.of(context).colorScheme.secondary
                          : widget.unselectedItemColor,
                      borderRadius:
                          widget.itemBorderRadius ?? BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        _items[index].label,
                        style: TextStyle(
                          fontSize: widget.itemLabelFontSize ??
                              theme(context).textTheme.titleSmall?.fontSize,
                          color: selected
                              //Selected
                              ? isDark
                                  ? widget.selectedItemTextDarkThemeColor ??
                                      CColors.switchable(context,
                                          dark: CColors.fancyBlack,
                                          light: Colors.white)
                                  : widget.selectedItemTextLightThemeColor ??
                                      Colors.white
                              //Unselected
                              : isDark
                                  ? widget.unselectedItemTextDarkThemeColor ??
                                      CColors.switchable(context,
                                          dark: Colors.white,
                                          light: CColors.secondary(context))
                                  : widget.unselectedItemTextLightThemeColor ??
                                      CColors.fancyBlack,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        PositionedDirectional(
          end: 0,
          top: 0,
          bottom: 0,
          child: AnimatedBuilder(
            animation: _scrollController,
            builder: (context, child) {
              final _child = child!;
              if (!_scrollController.position.hasContentDimensions) {
                return _child;
              }
              final maxExtent = _scrollController.position.maxScrollExtent;
              final atEnd = _scrollController.offset * 1 >= maxExtent;
              final atPreEnd = _scrollController.offset * 1.2 >= maxExtent;
              return Visibility(
                visible: !atEnd,
                child: AnimatedOpacity(
                  opacity: atPreEnd ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: _child,
                ),
              );
            },
            child: GestureDetector(
              onTap: () {
                _scrollController.animateTo(
                  _scrollController.offset + size.width / 3,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.decelerate,
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 7),
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: CColors.secondary(context),
                  borderRadius: BorderRadiusDirectional.horizontal(
                    start: Radius.circular(10),
                  ),
                ),
                child: Icon(
                  context.locale.isArabic
                      ? Icons.arrow_forward
                      : Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  BoxBorder _border(int index) {
    Color _selected = widget.selectedItemBorderColor ?? CColors.fancyBlack;
    Color _notSelected = widget.unselectedItemBorderColor ?? Colors.grey[800]!;
    return Border.all(
      color: _items[index].isSelected ? _selected : _notSelected,
    );
  }
}

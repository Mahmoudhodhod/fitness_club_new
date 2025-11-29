import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///[Visible] predicate funcation.
typedef PredicateCallBack<T> = bool Function(BuildContext context, T value);

///Gives you the control to view the child or its replacment widget in the condition of
///[predicate] callback.
///
class Visible<T> extends StatelessWidget {
  /// The [ValueListenable] whose value you depend on in order to build.
  ///
  /// This widget does not ensure that the [ValueListenable]'s value is not
  /// null, therefore your [builder] may need to handle null values.
  ///
  /// This [ValueListenable] itself must not be null.
  final ValueListenable<T> valueListenable;

  ///The child widget which will be visiable at the condition of [predicate].
  ///
  final Widget child;

  ///The condition to show to child, if it returned `true` the child will be visible.
  ///and vise versa.
  final PredicateCallBack<T> predicate;

  ///The replacment widget which will be displayed in the case of [predicate] returns `false`.
  ///
  final Widget? replacement;

  ///Defaults to `true`, if is `false` the [child] will be diplayed whether
  ///[predicate] returns `true` or `false`.
  ///
  final bool enable;

  ///Creates a widget selector [Visible] widget.
  ///
  const Visible({
    Key? key,
    required this.valueListenable,
    required this.child,
    required this.predicate,
    this.replacement,
    this.enable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: valueListenable,
      builder: (context, value, child) {
        if (replacement == null || !enable) return child!;
        bool condition = predicate(context, value);
        if (condition) return child!;
        return replacement!;
      },
      child: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:the_coach/Helpers/colors.dart';
import 'package:utilities/utilities.dart';

///Custom elevated button with loading indicator.
///
///See also:
///- `ElevatedButton()`
///
class CustomButton extends StatefulWidget {
  ///Button child.
  final Widget child;

  ///Callback triggered when the button is pressed for one time.
  final VoidCallback? onPressed;

  ///When `true` a loading indicator shows and the button becomes not responding to touch.
  final bool isLoading;

  ///Loading indicator widget, shows when the `isLoading` property is `True`
  final Widget? progressIndicator;

  ///Button's border radius, defaults to `BorderRadius.all(Radius.circular(5))`.
  final BorderRadiusGeometry? borderRadius;

  ///determine if the current button is enabled and the user can press or not,
  ///defaults to `true`
  final bool enabled;

  final VisualDensity? visualDensity;

  ///Custom elevated button with loading indicator.
  ///
  const CustomButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.isLoading = false,
    this.progressIndicator,
    this.enabled = true,
    this.borderRadius,
    this.visualDensity,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isLoading = false;
  bool _isEnabled = true;

  @override
  void initState() {
    _isLoading = widget.isLoading;
    _isEnabled = widget.enabled;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomButton oldWidget) {
    if (widget.isLoading != oldWidget.isLoading) {
      setState(() => _isLoading = widget.isLoading);
    }
    if (widget.enabled != oldWidget.enabled) {
      setState(() => _isEnabled = widget.enabled);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final _color = CColors.switchable(context,
        dark: CColors.fancyBlack, light: Colors.white);
    return Stack(
      alignment: Alignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            visualDensity: widget.visualDensity ?? VisualDensity.compact,
            shape: RoundedRectangleBorder(
                borderRadius: widget.borderRadius ?? KBorders.bc15),
            backgroundColor: CColors.switchable(context,
                dark: Colors.white, light: CColors.secondary(context)),
          ),
          onPressed: () {
            if (_isLoading || !_isEnabled) return;
            widget.onPressed?.call();
          },
          child: DefaultTextStyle(
            style:
                theme(context).textTheme.bodyLarge?.copyWith(color: _color) ??
                    const TextStyle(),
            child: widget.child,
          ),
        ),
        if (_isLoading || !_isEnabled) ...[
          Positioned.fill(
            child: Container(
              key: const Key("CustomButton_overlay"),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: widget.borderRadius ?? KBorders.bc15,
              ),
            ),
          ),
          if (_isLoading)
            widget.progressIndicator ?? _buildDefaultLoadingIndicator(),
        ]
      ],
    );
  }

  Widget _buildDefaultLoadingIndicator() {
    return SizedBox.fromSize(
      size: const Size.square(20),
      child: const CircularProgressIndicator(strokeWidth: 4),
    );
  }
}

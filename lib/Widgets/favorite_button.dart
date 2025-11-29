import 'package:flutter/material.dart';

///Animated favorite button.
class FavoriteButton extends StatefulWidget {
  ///On change callback which returns the current favorite value `true` or `false`.
  ///
  ///This property must not be null.
  final ValueChanged<bool> onChanged;

  ///favorite icon size, defaults to `60.0`.
  final double? iconSize;

  ///favorite icon active color, defaults to `Colors.red`.
  final Color? iconColor;

  ///whether this button is checked or not.
  ///
  ///Note: changing this value when running doesn't change the actual state of the widget.
  final bool? isFavorite;

  ///favorite icon inactive color, defaults to `Color(0xFFBDBDBD)`.
  final Color? iconDisabledColor;

  ///Animated favorite button.
  const FavoriteButton({
    Key? key,
    required this.onChanged,
    this.iconSize = 60.0,
    this.iconColor = Colors.red,
    this.isFavorite,
    this.iconDisabledColor = const Color(0xFFBDBDBD),
  }) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _sizeAnimation;

  late CurvedAnimation _curve;

  double _maxIconSize = 0.0;
  double _minIconSize = 0.0;

  final int _animationTime = 400;

  bool _isFavorite = false;

  @override
  void didUpdateWidget(covariant FavoriteButton oldWidget) {
    if (widget.isFavorite != oldWidget.isFavorite) {
      setState(() {
        _isFavorite = widget.isFavorite ?? false;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();

    _isFavorite = widget.isFavorite ?? false;

    double _iconSize = widget.iconSize ?? 60;
    _maxIconSize = (_iconSize < 20.0)
        ? 20.0
        : (_iconSize > 100.0)
            ? 100.0
            : _iconSize;
    final double _sizeDifference = _maxIconSize * 0.30;
    _minIconSize = _maxIconSize - _sizeDifference;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _animationTime),
    );

    _curve = CurvedAnimation(curve: Curves.slowMiddle, parent: _controller);
    Animation<Color?> _selectedColorAnimation = ColorTween(
      begin: widget.iconColor,
      end: widget.iconDisabledColor,
    ).animate(_curve);

    Animation<Color?> _deSelectedColorAnimation = ColorTween(
      begin: widget.iconDisabledColor,
      end: widget.iconColor,
    ).animate(_curve);

    _colorAnimation = (_isFavorite == true) ? _selectedColorAnimation : _deSelectedColorAnimation;
    _sizeAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: _minIconSize,
            end: _maxIconSize,
          ),
          weight: 50,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: _maxIconSize,
            end: _minIconSize,
          ),
          weight: 50,
        ),
      ],
    ).animate(_curve);

    // _controller.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     _isFavorite = !_isFavorite;
    //     widget.onChanged(_isFavorite);
    //   } else if (status == AnimationStatus.dismissed) {
    //     _isFavorite = !_isFavorite;
    //     widget.onChanged(_isFavorite);
    //   }
    // });
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        return InkResponse(
          onTap: () {
            _animate();
            _isFavorite = !_isFavorite;
            widget.onChanged(_isFavorite);
          },
          child: Icon(
            (Icons.favorite),
            color: _colorAnimation.value,
            size: _sizeAnimation.value,
          ),
        );
      },
    );
  }

  void _animate() {
    _controller.isCompleted ? _controller.reverse() : _controller.forward();
  }
}

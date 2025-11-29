import 'package:flutter/material.dart';
import 'package:the_coach/Helpers/colors.dart';

///[TextButton] which has a favorite icon.
///
///See also:
///* [TextButton.icon]: Create a text button from a pair of widgets that serve as the button's [icon] and [label].
///
class FavoriteTextButton extends StatelessWidget {
  ///Button title.
  final String title;

  ///Button [onPressed] callback.
  final ValueChanged<bool>? onPressed;

  ///Button syle.
  final ButtonStyle? style;

  ///favorite state, defaults to: `false`.
  final bool isFav;

  ///[TextButton] which has a favorite icon.
  const FavoriteTextButton({
    Key? key,
    required this.title,
    this.onPressed,
    this.style,
    this.isFav = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData _favIcon = isFav ? Icons.favorite : Icons.favorite_border_sharp;
    return TextButton.icon(
      onPressed: () => onPressed?.call(!isFav),
      style: TextButton.styleFrom(
        backgroundColor:
            CColors.nullableSwitchable(context, dark: Colors.white),
      ).merge(style),
      icon: Icon(
        _favIcon,
        color: isFav
            ? CColors.mainRed
            : CColors.nullableSwitchable(context,
                dark: CColors.fancyBlack,
                light: CColors.switchableBlackAndWhite),
      ),
      label: Text(title),
    );
  }
}

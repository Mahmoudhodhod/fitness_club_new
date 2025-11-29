import 'package:flutter/material.dart';
import 'package:the_coach/Helpers/colors.dart';

class FavoriteIcon extends StatelessWidget {
  ///whether to show a stock heart or outlined.
  final bool isFav;

  ///favorite icon size, defaults to: `27`.
  ///
  final double? iconSize;

  const FavoriteIcon({
    Key? key,
    required this.isFav,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData _favIcon = isFav ? Icons.favorite : Icons.favorite_border_sharp;
    return Icon(
      _favIcon,
      size: iconSize ?? 27,
      color: isFav ? CColors.mainRed : Colors.grey,
    );
  }
}

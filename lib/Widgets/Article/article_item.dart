import 'package:flutter/material.dart';
import 'package:the_coach/Widgets/widgets.dart';

///Article's item.
///
class ArticleItem extends StatelessWidget {
  ///Article center title.
  final String title;

  ///Article header image path.
  final String imagePath;

  ///Is the current user make is Article his favorite.
  final bool isFavorite;

  final VoidCallback? onTap;

  ///Article's item.
  ///
  const ArticleItem({
    Key? key,
    required this.title,
    required this.imagePath,
    this.onTap,
    this.isFavorite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return JokerListTile(
      onTap: onTap,
      titleText: title,
      imagePath: imagePath,
      contentPadding: EdgeInsetsDirectional.only(end: 10),
      trailing: Align(
        alignment: AlignmentDirectional(0.9, -0.7),
        child: FavoriteIcon(isFav: isFavorite),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:utilities/utilities.dart';

import '../network_image.dart';

class DayExerciseVideoTile extends StatelessWidget {
  final String thumbnailImageUrl;
  final VoidCallback? onTap;

  const DayExerciseVideoTile({
    Key? key,
    required this.thumbnailImageUrl,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const playIconSize = 80.0;
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: screenSize.height * .25,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: KBorders.bc10,
          ),
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              Positioned.fill(
                child: NetworkImageView(
                  url: thumbnailImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Icon(
                  Icons.play_circle_fill_sharp,
                  color: Colors.white60,
                  size: playIconSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

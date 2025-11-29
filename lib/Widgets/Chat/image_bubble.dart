import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:the_coach/Widgets/widgets.dart';
import 'package:utilities/utilities.dart';

///Creates an image bubble which can display the chat image.
///
///and when tapped opens an image viewer.
///
class ImageBubble extends StatelessWidget {
  ///Displayed image path.
  ///
  final String imagePath;

  ///Displayed bubble type [BubbleType.receiverBubble] or [BubbleType.sendBubble].
  ///
  final BubbleType type;

  ///The time at which the current chat message was sent.
  ///
  final DateTime createdAt;

  ///Creates an image bubble which can display the chat image.
  const ImageBubble({
    Key? key,
    required this.imagePath,
    required this.type,
    required this.createdAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    const borderRadius = BorderRadius.all(Radius.circular(5));
    return Row(
      textDirection: getChatBubbleTextDirection(type),
      children: [
        ClipRRect(
          borderRadius: borderRadius,
          child: GestureDetector(
            onTap: () => SlideShow(images: [_imageProvider()]).show(context),
            child: Container(
              constraints: BoxConstraints.loose(
                  Size(_size.width * 0.6, _size.height * 0.2)),
              child: Stack(
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: _buildImageViewer(),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 100,
                    child: Stack(
                      children: [
                        ShaderMask(
                          shaderCallback: (rect) {
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.5, 1],
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(1)
                              ],
                            ).createShader(
                                Rect.fromLTRB(0, -150, rect.width, 0));
                          },
                          blendMode: BlendMode.srcIn,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(.9, .9),
                          child: SentTime(
                            time: createdAt,
                            style: theme(context).textTheme.bodySmall,
                            onlyShowTime: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageViewer() {
    return Image(
      image: _imageProvider(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[600]!,
            highlightColor: Colors.grey[300]!,
            child: const SizedBox.expand(child: Icon(Icons.image, size: 70)),
          ),
        );
      },
      errorBuilder: (_, __, ___) {
        return SizedBox.expand(
          child: const Center(
            child: Icon(
              Icons.error,
              size: 70,
              color: Colors.red,
            ),
          ),
        );
      },
    );
  }

  ImageProvider _imageProvider() {
    if (imagePath.isUrl()) {
      return NetworkImage(imagePath);
    }
    return FileImage(File(imagePath));
  }
}

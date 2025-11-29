import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:the_coach/Helpers/colors.dart';

class YoutubeVideoPlayer extends StatefulWidget {
  final String url;

  ///
  ///Use [show(BuildContext)] to display as a bottom sheet.
  ///
  const YoutubeVideoPlayer({
    Key? key,
    required this.url,
  }) : super(key: key);

  Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => this,
      isScrollControlled: true,
      barrierColor: Colors.black87,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: const Radius.circular(20.0),
        ),
      ),
    );
  }

  ///Grabs YouTube video's thumbnail for provided video id.
  ///
  static String? getVideoThumbNail(String url) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId == null) return null;
    return YoutubePlayer.getThumbnail(videoId: videoId);
  }

  @override
  _YoutubeVideoPlayerState createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    _initPlayerController();
    super.initState();
  }

  void _initPlayerController() {
    final videoId = YoutubePlayer.convertUrlToId(widget.url);
    assert(videoId != null);
    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
    );
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressColors: ProgressBarColors(
          playedColor: CColors.secondary(context),
          handleColor: CColors.secondary(context),
        ),
      ),
      builder: (context, player) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
            child: player,
          ),
        );
      },
    );
  }
}

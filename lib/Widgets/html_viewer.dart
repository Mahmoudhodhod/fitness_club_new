import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Widgets/widgets.dart';

//TODO: document
class HTMLViewer extends StatelessWidget {
  final String data;
  const HTMLViewer({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      data,
      // onTapImage: (url) async{
      //   SlideShow(images: [NetworkImage(url)]).show(context);
      // },
      onTapUrl: (url) async {
        await launchUri(url);
        return true;
      },
    );
  }
}


/*
Html(
      data: data,
      onLinkTap: (url, _, __, ___) {
        if (url != null) launchUri(url);
      },
      onImageTap: (url, _, __, ___) {
        if (url == null) return;
        SlideShow(images: [NetworkImage(url)]).show(context);
      },
    );

*/
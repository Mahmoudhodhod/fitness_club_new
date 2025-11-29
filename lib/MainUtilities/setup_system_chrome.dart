import 'package:flutter/services.dart';
import 'package:the_coach/Helpers/colors.dart';

void setUpSystemChrome() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: CColors.fancyBlack, // navigation bar color
    statusBarColor: CColors.fancyBlack, // status bar color
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
  ));
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
}

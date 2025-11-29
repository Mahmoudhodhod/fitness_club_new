import 'package:the_coach/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

///A place holder abstract picker localization.
///
///you can use when dealing with localizing the picker lableds.
///
abstract class PickerLocalization {
  const PickerLocalization();

  ///Camera roll label.
  String get camera;

  ///photo library or Galery label.
  String get library;

  String get mediaSource;
}

///English localization delegate.
class EnglishPickerLocale implements PickerLocalization {
  const EnglishPickerLocale();
  @override
  String get camera => "Camera Roll";

  @override
  String get library => "Photoes Library";

  @override
  String get mediaSource => "Media Source";
}

///English localization delegate.
class ArabicPickerLocale implements PickerLocalization {
  const ArabicPickerLocale();
  @override
  String get camera => LocaleKeys.general_titles_camera_roll.tr();

  @override
  String get library => LocaleKeys.general_titles_images_library.tr();

  @override
  String get mediaSource => LocaleKeys.general_titles_media_souce.tr();
}

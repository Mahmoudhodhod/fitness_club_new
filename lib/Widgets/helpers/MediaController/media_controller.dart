import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';

import 'exceptions.dart';
import 'interface.dart';
import 'localization.dart';

export 'exceptions.dart';
export 'localization.dart';
export 'interface.dart';

///A very simple and easy to use [ImagePicker] wrapper, by which you can pick a `single` image
///or a select `multimage` using an image picker view.
///
///to use you have to call `init` with an [ImagePicker] instance in `main` function
///then you can use the static `instance` to access the controller.
///
class MediaController {
  final MediaPicker? _mediaPicker;

  ///The controller's localization settings.
  PickerLocalization _localization = const EnglishPickerLocale();

  ///Localization labels getter.
  PickerLocalization get _locale => _localization;

  ///Localization labels, used to change the labels of the picker widget to match
  ///the current language on the fly.
  ///
  ///use presets ones like `EnglishPickerLocale` or `ArablicPickerLocale`.
  ///defaults to `EnglishPickerLocale`.
  set localization(PickerLocalization localization) {
    _localization = localization;
    log("🎉 [MediaController] localization has been updated");
  }

  MediaController._({
    ///the image picker responsible for picking and selecting a single image.
    ///
    required MediaPicker picker,
  }) : _mediaPicker = picker;

  static MediaController? _instance;

  ///shared instance of [MediaController].
  static MediaController get instance {
    if (_instance == null) throw NullMediaController();
    return _instance!;
  }

  ///initialize the media controller with an [ImagePicker] to pick single images
  ///at once.
  ///
  ///Must call in `main`.
  static void init(MediaPicker picker) {
    _instance = MediaController._(picker: picker);
  }

  ///Used to open an image picker view or a cemera to select or pick
  ///the required image.
  ///
  ///if you want to select more than one image, you should assign the max number
  ///of images using `imagesLimit`.
  ///
  Future<List<File>?> openSheetAndPickImage(
    BuildContext context, {
    int imagesLimit = 1,
  }) async {
    final _isSingleImage = imagesLimit == 1 || imagesLimit == 0;

    final _imageSource = await _showPickerSheet<ImageSource>(
      context: context,
      mutli: !_isSingleImage,
    );
    if (_imageSource == null) return null;

    return await pickImage(imagesLimit: imagesLimit, source: _imageSource);
  }

  ///Used to pick the image directly from camer or library
  ///you can select the image source using [source].
  ///
  ///if you want to select more than one image, you should assign the max number
  ///of images using `imagesLimit`.
  ///
  Future<List<File>?> pickImage({
    int imagesLimit = 1,
    ImageSource source = ImageSource.gallery,
  }) async {
    _controllerAssertion();
    final _isSingleImage = imagesLimit == 1 || imagesLimit == 0;

    List<File> _imageFiles;

    //? Single image

    if (_isSingleImage) {
      File? _image;
      _image = await _pickImage(source);
      if (_image == null) return null;
      _imageFiles = [_image];
    } else {
      //? Multimage
      final _images = await _pickMultiImages(imagesLimit);
      if (_images == null) return null;
      _imageFiles = _images;
    }

    return Future.value(_imageFiles);
  }

  ///Pick more than one image using [MultiImagePicker].
  ///
  Future<List<File>?> _pickMultiImages(int imagesLimit) async {
    final _files = await _mediaPicker!.pickImages(maxImages: imagesLimit);
    return Future.value(_files);
  }

  ///Picks a single image using [ImagePicker].
  Future<File?> _pickImage(ImageSource imageSource) async {
    final _pickedFile = await _mediaPicker!.pickImage(source: imageSource);
    return _pickedFile;
  }

  ///Displays the image picker model sheet.
  ///
  Future<T?> _showPickerSheet<T>({
    required BuildContext context,
    bool mutli = false,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
            const BorderRadius.vertical(top: const Radius.circular(20)),
      ),
      builder: (_) {
        return _ImageSourcePicker(
          multiImage: mutli,
          localization: _locale,
        );
      },
    );
  }

  void _controllerAssertion() {
    if (_mediaPicker == null) throw NullMediaController();
  }

  ///Disposes call singleton instance.
  ///Use only when testing.
  @visibleForTesting
  static void disposeInstance() {
    _instance = null;
  }
}

class _ImageSourcePicker extends StatelessWidget {
  ///do you want to select more than one image?
  ///
  final bool multiImage;

  ///the picker labels localization delegate.
  ///
  final PickerLocalization localization;
  const _ImageSourcePicker({
    Key? key,
    required this.localization,
    this.multiImage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.vertical(top: const Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                localization.mediaSource,
                key: const Key("localization_mediaSource"),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
            Divider(),
            ListTile(
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              leading: Icon(FontAwesomeIcons.images),
              title: Text(
                localization.library,
                key: const Key("localization_library"),
                style: TextStyle(fontSize: 13),
              ),
            ),
            if (!multiImage)
              ListTile(
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
                leading: Icon(FontAwesomeIcons.camera),
                title: Text(
                  localization.camera,
                  key: const Key("localization_camera"),
                  style: TextStyle(fontSize: 13),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
//import 'package:get/get.dart';
// import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'package:image_picker/image_picker.dart';
// import 'package:multi_image_picker/multi_image_picker.dart';

///picker interface to deal with picking data.
///
abstract class MediaPicker {
  ///Pick multiImage with a max of [maxImages].
  Future<List<File>?> pickImages({
    required int maxImages,
    bool enableCamera = true,
  }) {
    throw UnimplementedError(
        "Impelement [pickImages()] in [$this] then use it.");
  }

  ///Pick a single image from [source].
  Future<File?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) {
    throw UnimplementedError(
        "Impelement [pickImage()] in [$this] then use it.");
  }
}

///use to pick images and media in general on iOS and Android.
///
class AppMediaPicker extends MediaPicker {
  final ImagePicker _imagePicker;

  ///Constructs a media picker with an image picker.
  ///
  ///if not, an image picker is constructed automaticly.
  ///
  AppMediaPicker({ImagePicker? picker})
      : _imagePicker = picker ?? ImagePicker();

  @override
  Future<File?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) async {
    final _xFile = await _imagePicker.pickImage(
      source: source,
      imageQuality: imageQuality,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
    );
    if (_xFile == null) return null;
    return File(_xFile.path);
  }

  @override
  Future<List<File>?> pickImages(
      {required int maxImages, bool enableCamera = true}) async {
    try {
      final _resultAssetsList = await MultiImagePicker.pickImages(
        androidOptions: AndroidOptions(
          maxImages: maxImages,
        ),
        // maxImages: maxImages,
        // enableCamera: enableCamera,
      );

      List<File> _files = await _assetsToFiles(_resultAssetsList);

      return _files;
    } on NoImagesSelectedException catch (e) {
      log("User Cancelled Celection: $e");
      return null;
    }
  }

  Future<List<File>> _assetsToFiles(List<Asset> _images) async {
    List<File> _tempProblemImages = [];
    for (var index = 0; index < _images.length; index++) {
      final _asset = _images[index];
      final _bytes = await _asset.getByteData();
      final _file = await _writeToFile(_bytes, _asset.name);
      _tempProblemImages.add(_file);
    }
    return Future.value(_tempProblemImages);
  }

  Future<File> _writeToFile(ByteData data, String? path) async {
    final buffer = data.buffer;
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    final int _genCode = math.Random().nextInt(999);
    var filePath = tempPath + '/${path ?? _genCode}.tmp';
    return new File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
}

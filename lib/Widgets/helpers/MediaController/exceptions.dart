import 'package:utilities/utilities.dart';

///Throwen when an error happen with the image picking operation.
///
class PickingImageFailed extends AppException {
  ///The cought and thrown exception object.
  ///
  final Object? exception;
  const PickingImageFailed({this.exception})
      : super("Picking an image returned with failure "
            "please check the givin object");

  @override
  String toString() => "PickingImageFailed($msg, details: $exception)";
}

///throwed when the media controller not initialized properly.
///
class NullMediaController extends AppException {
  const NullMediaController()
      : super("you must call `init()` in main "
            "before trying to use the controller");
}

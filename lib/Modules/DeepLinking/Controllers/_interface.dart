import '../Models/models.dart';

abstract class DeepLinkingProcess<T> {
  Future<T> executeProcess(ApiOptions options);
  void onProcessFinished(T data);
}

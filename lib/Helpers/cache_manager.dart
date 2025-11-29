import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AppDefaultCacheManager extends CacheManager with ImageCacheManager {
  static const key = 'customer_app_cache_manager';

  static final _instance = AppDefaultCacheManager._();
  factory AppDefaultCacheManager() => _instance;

  AppDefaultCacheManager._()
      : super(
          Config(
            key,
            stalePeriod: const Duration(days: 66),
            maxNrOfCacheObjects: 1500,
          ),
        );
}

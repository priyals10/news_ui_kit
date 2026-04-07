import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// An extended CacheManager that keeps images for 15 days
/// so they are available even when the device goes offline.
class CustomCacheManager extends CacheManager {
  static const key = 'newsImageCache';

  static final CustomCacheManager _instance = CustomCacheManager._();
  factory CustomCacheManager() => _instance;

  CustomCacheManager._()
      : super(Config(
          key,
          stalePeriod: const Duration(days: 15),
          maxNrOfCacheObjects: 300,
        ));

  /// Singleton for easy access
  static CustomCacheManager get instance => _instance;
}

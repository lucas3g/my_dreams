import 'package:package_info_plus/package_info_plus.dart';

/// Service responsible for providing application information.
class AppInfoService {
  AppInfoService._();

  /// Singleton instance of [AppInfoService].
  static final AppInfoService instance = AppInfoService._();

  String? _version;

  /// Returns the current application version.
  Future<String> getVersion() async {
    if (_version != null) return _version!;
    final info = await PackageInfo.fromPlatform();
    _version = info.version;
    return _version!;
  }
}

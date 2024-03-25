import 'package:catcher_2/model/application_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';

class ApplicationProfileManager {
  /// Get current application profile (release, debug or profile).
  static ApplicationProfile getApplicationProfile() {
    if (kReleaseMode) {
      return ApplicationProfile.release;
    }
    if (kDebugMode) {
      return ApplicationProfile.debug;
    }
    if (kProfileMode) {
      return ApplicationProfile.profile;
    }

    /// Fallback
    return ApplicationProfile.debug;
  }

  /// Check if current platform is Web
  static bool isWeb() => kIsWeb;

  /// Check if current platform is Android
  static bool isAndroid() => !kIsWeb && Platform.isAndroid;

  /// Check if current platform is iOS
  static bool isIos() => !kIsWeb && Platform.isIOS;

  /// Check if current platform is Linux
  static bool isLinux() => !kIsWeb && Platform.isLinux;

  /// Check if current platform is Windows
  static bool isWindows() => !kIsWeb && Platform.isWindows;

  /// Check if current platform is macOS
  static bool isMacOS() => !kIsWeb && Platform.isMacOS;
}

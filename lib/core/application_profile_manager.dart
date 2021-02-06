import 'dart:io';

import 'package:catcher/model/application_profile.dart';
import 'package:flutter/foundation.dart';

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

    ///Fallback
    return ApplicationProfile.debug;
  }

  /// Check if current platform is web
  static bool isWeb() => kIsWeb;

  /// Check if current platform is android
  static bool isAndroid() => Platform.isAndroid;

  /// Check if current platform is ios
  static bool isIos() => Platform.isIOS;

  /// Check if current platform is ios
  static bool isMacOS() => Platform.isMacOS;

  /// Check if current platform is ios
  static bool isWindows() => Platform.isWindows;
}

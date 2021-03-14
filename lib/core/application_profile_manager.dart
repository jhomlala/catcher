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
  static bool isAndroid() => !kIsWeb && Platform.isAndroid;

  /// Check if current platform is ios
  static bool isIos() => !kIsWeb && Platform.isIOS;

  ///Check if current platform is linux
  static bool isLinux() => !kIsWeb && Platform.isLinux;

  ///Check if current platform is windows
  static bool isWindows() => !kIsWeb && Platform.isWindows;

  ///Check if current platform is macOS
  static bool isMacOS() => !kIsWeb && Platform.isMacOS;
}

import 'package:catcher/model/application_profile.dart';
import 'package:flutter/foundation.dart';

class ApplicationProfileManager {
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

  static bool isWeb() {
    return kIsWeb;
  }
}

import 'package:catcher/model/application_profile.dart';

class ApplicationProfileManager {
  static ApplicationProfile getApplicationProfile() {
    if (bool.fromEnvironment("dart.vm.product") == true) {
      return ApplicationProfile.release;
    } else if (_isDebug()) {
      return ApplicationProfile.debug;
    } else {
      return ApplicationProfile.profile;
    }
  }

  static bool _isDebug() {
    bool debugFlag = false;
    assert(debugFlag = true);
    return debugFlag;
  }
}

import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';

import 'localization_options.dart';

abstract class ReportHandler {
  /// Method called when report has been accepted by user
  Future<bool> handle(Report error);

  /// Get list of supported platforms
  List<PlatformType> getSupportedPlatforms();

  ///Location settings
  LocalizationOptions _localizationOptions;

  /// Get currently used localization options
  LocalizationOptions get localizationOptions => _localizationOptions;

  /// Set localization options (translations) to this report mode
  void setLocalizationOptions(LocalizationOptions localizationOptions) {
    assert(localizationOptions != null, "LocalizationOptions can't be null");
    this._localizationOptions = localizationOptions;
  }
}

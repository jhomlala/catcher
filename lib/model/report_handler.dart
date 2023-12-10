import 'package:catcher_2/model/localization_options.dart';
import 'package:catcher_2/model/platform_type.dart';
import 'package:catcher_2/model/report.dart';
import 'package:catcher_2/utils/catcher_2_logger.dart';
import 'package:flutter/material.dart';

abstract class ReportHandler {
  /// Logger instance
  late Catcher2Logger logger;

  /// Localization settings
  LocalizationOptions? _localizationOptions;

  /// Method called when report has been accepted by user
  Future<bool> handle(Report report, BuildContext? context);

  /// Get list of supported platforms
  List<PlatformType> getSupportedPlatforms();

  /// Get currently used localization options
  LocalizationOptions get localizationOptions =>
      _localizationOptions ?? LocalizationOptions.buildDefaultEnglishOptions();

  /// Set localization options (translations) to this report mode
  set localizationOptions(LocalizationOptions? localizationOptions) {
    _localizationOptions = localizationOptions;
  }

  /// Check if given report mode requires context to run
  bool isContextRequired() => false;

  /// Check whether report mode should auto confirm without user confirmation.
  bool shouldHandleWhenRejected() => false;
}

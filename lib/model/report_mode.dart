import 'package:catcher_2/mode/report_mode_action_confirmed.dart';
import 'package:catcher_2/model/localization_options.dart';
import 'package:catcher_2/model/platform_type.dart';
import 'package:catcher_2/model/report.dart';
import 'package:flutter/widgets.dart';

abstract class ReportMode {
  late ReportModeAction _reportModeAction;
  LocalizationOptions? _localizationOptions;

  /// Set report mode action.
  // ignore: avoid_setters_without_getters
  set reportModeAction(ReportModeAction reportModeAction) {
    _reportModeAction = reportModeAction;
  }

  /// Set localization options (translations) to this report mode
  set localizationOptions(LocalizationOptions? localizationOptions) {
    _localizationOptions = localizationOptions;
  }

  /// Code which should be triggered if new error has been caught and core
  /// creates report about this.
  void requestAction(Report report, BuildContext? context);

  /// On user has accepted report
  void onActionConfirmed(Report report) {
    _reportModeAction.onActionConfirmed(report);
  }

  /// On user has rejected report
  void onActionRejected(Report report) {
    _reportModeAction.onActionRejected(report);
  }

  /// Check if given report mode requires context to run
  bool isContextRequired() => false;

  /// Get currently used localization options
  LocalizationOptions get localizationOptions =>
      _localizationOptions ?? LocalizationOptions.buildDefaultEnglishOptions();

  /// Get supported platform list
  List<PlatformType> getSupportedPlatforms();
}

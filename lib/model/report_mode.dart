import 'package:catcher/mode/report_mode_action_confirmed.dart';
import 'package:catcher/model/localization_options.dart';
import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:flutter/widgets.dart';

abstract class ReportMode {
  ReportModeAction _reportModeAction;
  LocalizationOptions _localizationOptions;

  /// Set report mode action.
  void setReportModeAction(ReportModeAction reportModeAction) {
    this._reportModeAction = reportModeAction;
  }
  /// Set localization options (translations) to this report mode
  void setLocalizationOptions(LocalizationOptions localizationOptions) {
    this._localizationOptions = localizationOptions;
  }

  /// Code which should be triggered if new error has been catched and core
  /// creates report about this.
  void requestAction(Report report, BuildContext context);

  /// On user has accepted report
  void onActionConfirmed(Report report) {
    _reportModeAction.onActionConfirmed(report);
  }

  /// On user has rejected report
  void onActionRejected(Report report) {
    _reportModeAction.onActionRejected(report);
  }

  /// Check if given report mode requires context to run
  bool isContextRequired() {
    return false;
  }

  /// Get currently used localization options
  LocalizationOptions get localizationOptions => _localizationOptions;

  /// Get supported platform list
  List<PlatformType> getSupportedPlatforms();
}

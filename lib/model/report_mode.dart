import 'package:catcher/mode/report_mode_action_confirmed.dart';
import 'package:catcher/model/localization_options.dart';
import 'package:catcher/model/report.dart';
import 'package:flutter/widgets.dart';

abstract class ReportMode {
  ReportModeAction _reportModeAction;
  LocalizationOptions _localizationOptions;

  void setReportModeAction(ReportModeAction reportModeAction) {
    this._reportModeAction = reportModeAction;
  }

  void setLocalizationOptions(LocalizationOptions localizationOptions){
    this._localizationOptions = localizationOptions;
  }

  void requestAction(Report report, BuildContext context);

  void onActionConfirmed(Report report) {
    _reportModeAction.onActionConfirmed(report);
  }

  void onActionRejected(Report report) {
    _reportModeAction.onActionRejected(report);
  }

  bool isContextRequired(){
    return false;
  }

  LocalizationOptions get localizationOptions => _localizationOptions;
}

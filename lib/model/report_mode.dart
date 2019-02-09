import 'package:catcher/mode/report_mode_action_confirmed.dart';
import 'package:catcher/model/report.dart';
import 'package:flutter/widgets.dart';

abstract class ReportMode {
  ReportModeAction _reportModeAction;

  setReportModeAction(ReportModeAction reportModeAction) {
    this._reportModeAction = reportModeAction;
  }

  void requestAction(Report report, BuildContext context);

  void onActionConfirmed(Report report) {
    _reportModeAction.onActionConfirmed(report);
  }

  void onActionRejected(Report report) {
    _reportModeAction.onActionRejected(report);
  }
}

import 'package:catcher/mode/report_mode_action_confirmed.dart';
import 'package:catcher/model/report.dart';
import 'package:flutter/widgets.dart';

abstract class ReportMode {
  final ReportModeAction reportModeAction;

  const ReportMode(this.reportModeAction);

  void requestAction(Report report, BuildContext context);

  void onActionConfirmed() {
    reportModeAction.onActionConfirmed();
  }

  void onActionRejected() {
    reportModeAction.onActionRejected();
  }
}

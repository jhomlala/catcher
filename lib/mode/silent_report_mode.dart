import 'package:catcher/mode/report_mode.dart';
import 'package:catcher/mode/report_mode_action_confirmed.dart';

class SilentReportMode extends ReportMode {
  const SilentReportMode(ReportModeAction reportModeAction)
      : super(reportModeAction);

  @override
  void requestAction() {
    // no action needed, request is automatically accepted
    reportModeAction.onActionConfirmed();
  }
}

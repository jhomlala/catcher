import 'package:catcher/mode/report_mode_action_confirmed.dart';

abstract class ReportMode {
  final ReportModeAction reportModeAction;
  const ReportMode(this.reportModeAction);

  void requestAction();

  void onActionConfirmed(){
    reportModeAction.onActionConfirmed();
  }

  void onActionRejected(){
    reportModeAction.onActionRejected();
  }

}

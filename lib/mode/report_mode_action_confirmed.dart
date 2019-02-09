import 'package:catcher/model/report.dart';

abstract class ReportModeAction {
  void onActionConfirmed(Report report);

  void onActionRejected(Report report);
}

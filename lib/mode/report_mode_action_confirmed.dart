import 'package:catcher_2/model/report.dart';

abstract class ReportModeAction {
  /// Code which should be triggered if report mode has been confirmed
  void onActionConfirmed(Report report);

  /// Code which should be triggered if report mode has been rejected
  void onActionRejected(Report report);
}

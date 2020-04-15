import 'package:catcher/model/report_mode.dart';
import 'package:catcher/model/report.dart';
import 'package:flutter/material.dart';

class DialogReportMode extends ReportMode {
  @override
  void requestAction(Report report, BuildContext context) {
    _showDialog(report, context);
  }

  Future _showDialog(Report report, BuildContext context) async {
    await Future.delayed(Duration.zero);
    showDialog(
      context: context,
      builder: (BuildContext build) {
        return AlertDialog(
          title: Text(localizationOptions.dialogReportModeTitle),
          content: Text(localizationOptions.dialogReportModeDescription),
          actions: <Widget>[
            FlatButton(
              child: Text(localizationOptions.dialogReportModeAccept),
              onPressed: () => _onAcceptReportClicked(context, report),
            ),
            FlatButton(
              child: Text(localizationOptions.dialogReportModeCancel),
              onPressed: () => _onCancelReportClicked(context, report),
            ),
          ],
        );
      },
    );
  }

  void _onAcceptReportClicked(BuildContext context, Report report) {
    super.onActionConfirmed(report);
    Navigator.pop(context);
  }

  void _onCancelReportClicked(BuildContext context, Report report) {
    super.onActionRejected(report);
    Navigator.pop(context);
  }

  @override
  bool isContextRequired() {
    return true;
  }
}

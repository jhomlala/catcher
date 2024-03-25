import 'package:catcher_2/model/platform_type.dart';
import 'package:catcher_2/model/report.dart';
import 'package:catcher_2/model/report_mode.dart';
import 'package:catcher_2/utils/catcher_2_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogReportMode extends ReportMode {
  @override
  void requestAction(Report report, BuildContext? context) {
    _showDialog(report, context);
  }

  Future<void> _showDialog(Report report, BuildContext? context) async {
    await Future<void>.delayed(Duration.zero);
    if (context != null) {
      if (!context.mounted) {
        return;
      }
      if (Catcher2Utils.isCupertinoAppAncestor(context)) {
        return showCupertinoDialog<void>(
          context: context,
          builder: (context) => _buildCupertinoDialog(report, context),
        );
      } else {
        return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (context) => _buildMaterialDialog(report, context),
        );
      }
    }
  }

  Widget _buildCupertinoDialog(Report report, BuildContext context) =>
      // ignore: deprecated_member_use
      WillPopScope(
        onWillPop: () async {
          super.onActionRejected(report);
          return true;
        },
        child: CupertinoAlertDialog(
          title: Text(localizationOptions.dialogReportModeTitle),
          content: Text(localizationOptions.dialogReportModeDescription),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () => _onAcceptReportClicked(context, report),
              child: Text(localizationOptions.dialogReportModeAccept),
            ),
            CupertinoDialogAction(
              onPressed: () => _onCancelReportClicked(context, report),
              child: Text(localizationOptions.dialogReportModeCancel),
            ),
          ],
        ),
      );

  Widget _buildMaterialDialog(Report report, BuildContext context) =>
      // ignore: deprecated_member_use
      WillPopScope(
        onWillPop: () async {
          super.onActionRejected(report);
          return true;
        },
        child: AlertDialog(
          title: Text(localizationOptions.dialogReportModeTitle),
          content: Text(localizationOptions.dialogReportModeDescription),
          actions: <Widget>[
            TextButton(
              onPressed: () => _onAcceptReportClicked(context, report),
              child: Text(localizationOptions.dialogReportModeAccept),
            ),
            TextButton(
              onPressed: () => _onCancelReportClicked(context, report),
              child: Text(localizationOptions.dialogReportModeCancel),
            ),
          ],
        ),
      );

  void _onAcceptReportClicked(BuildContext context, Report report) {
    super.onActionConfirmed(report);
    Navigator.pop(context);
  }

  void _onCancelReportClicked(BuildContext context, Report report) {
    super.onActionRejected(report);
    Navigator.pop(context);
  }

  @override
  bool isContextRequired() => true;

  @override
  List<PlatformType> getSupportedPlatforms() => [
        PlatformType.android,
        PlatformType.iOS,
        PlatformType.web,
        PlatformType.linux,
        PlatformType.macOS,
        PlatformType.windows,
      ];
}

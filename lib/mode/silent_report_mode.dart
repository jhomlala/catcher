import 'package:athmany_catcher/model/platform_type.dart';
import 'package:athmany_catcher/model/report.dart';
import 'package:athmany_catcher/model/report_mode.dart';
import 'package:flutter/widgets.dart';

class SilentReportMode extends ReportMode {
  @override
  void requestAction(Report report, BuildContext? context) {
    // no action needed, request is automatically accepted
    super.onActionConfirmed(report);
  }

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

import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';

abstract class ReportHandler {
  ReportHandler();

  Future<bool> handle(Report error);

  List<PlatformType> getSupportedPlatforms();

  bool isReportHandlerSupportedInPlatform(Report report) =>
      getSupportedPlatforms().contains(report.platformType);
}

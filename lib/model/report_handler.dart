import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';

abstract class ReportHandler {
  /// Method called when report has been accepted by user
  Future<bool> handle(Report error);

  /// Get list of supported platforms
  List<PlatformType> getSupportedPlatforms();
}

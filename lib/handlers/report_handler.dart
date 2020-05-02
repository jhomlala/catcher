import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';

abstract class ReportHandler {
  ReportHandler();

  Future<bool> handle(Report error);

  List<PlatformType> getSupportedPlatforms();
}

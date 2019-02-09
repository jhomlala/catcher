import 'package:catcher/model/report.dart';

abstract class ReportHandler {
  ReportHandler();

  Future<bool> handle(Report error);
}

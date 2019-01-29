import 'package:catcher/report.dart';

abstract class ReportHandler{
  const ReportHandler();
  bool handle(Report error);
}
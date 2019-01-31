import 'package:catcher/model/report.dart';

abstract class ReportHandler{
  const ReportHandler();
  Future<bool> handle(Report error);
}
import 'package:catcher/report.dart';
import 'package:catcher/handlers/report_handler.dart';

class FileHandler extends ReportHandler{
  @override
  bool handle(Report error) {
    return true;
  }

}
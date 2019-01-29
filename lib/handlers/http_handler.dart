import 'package:catcher/report.dart';
import 'package:catcher/handlers/report_handler.dart';
import 'package:dio/dio.dart';

class HttpHandler extends ReportHandler {
  Dio _dio = Dio();
  final String endpoint;

  HttpHandler(this.endpoint);

  @override
  bool handle(Report error) {
    try {
      var json = error.toJson();
      _dio.post(endpoint, data: json);
      return true;
    } catch (error, stackTrace) {
      return false;
    }
  }
}

import 'package:catcher/handlers/report_handler.dart';
import 'package:catcher/model/http_request_type.dart';
import 'package:catcher/model/report.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

class HttpHandler extends ReportHandler {
  final Dio _dio = Dio();
  final HttpRequestType requestType;
  final Uri endpointUri;
  final Map<String, dynamic> headers;
  final int requestTimeout;
  final bool printLogs;

  HttpHandler(
      {this.requestType = HttpRequestType.post,
      @required this.endpointUri,
      this.headers = const {},
      this.requestTimeout = 1000,
      this.printLogs = false}) {
    assert(endpointUri != null, "Endpoint uri can't be null");
    assert(requestTimeout > 0, "Request timeout must be greather than 0");
  }

  @override
  Future<bool> handle(Report error) async {
    if (requestType == HttpRequestType.post) {
      return _sendPost(error);
    }
    return true;
  }

  Future<bool> _sendPost(Report error) async {
    try {
      var json = error.toJson();
      Options options =
          Options(connectTimeout: requestTimeout, headers: headers);
      Response response =
          await _dio.post(endpointUri.toString(), data: json, options: options);
      print(
          "HttpHandler response status: ${response.statusCode} body: ${response.data}");
      return SynchronousFuture(true);
    } catch (error, stackTrace) {
      printLog("HttpHandler error: $error, stackTrace: $stackTrace");
      return SynchronousFuture(false);
    }
  }

  printLog(String log) {
    if (printLogs) {
      print(log);
    }
  }

  @override
  String toString() {
    return 'HttpHandler';
  }


}

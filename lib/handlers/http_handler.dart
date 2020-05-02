import 'dart:collection';

import 'package:catcher/handlers/report_handler.dart';
import 'package:catcher/model/http_request_type.dart';
import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:catcher/utils/catcher_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class HttpHandler extends ReportHandler {
  final Dio _dio = Dio();
  final Logger _logger = Logger("HttpHandler");

  final HttpRequestType requestType;
  final Uri endpointUri;
  final Map<String, dynamic> headers;
  final int requestTimeout;
  final int responseTimeout;
  final bool printLogs;

  HttpHandler(this.requestType, this.endpointUri,
      {this.headers = const {},
      this.requestTimeout = 5000,
      this.responseTimeout = 5000,
      this.printLogs = false})
      : assert(requestType != null, "requestType can't be null"),
        assert(endpointUri != null, "endpointUri can't be null"),
        assert(requestTimeout != null, "requestTimeout can't be null"),
        assert(responseTimeout != null, "responseTimeout can't be null"),
        assert(printLogs != null, "printLogs can't be null");

  @override
  Future<bool> handle(Report error) async {
    if (error.platformType != PlatformType.Web) {
      if (!(await CatcherUtils.isInternetConnectionAvailable())) {
        _printLog("No internet connection available");
        return false;
      }
    }

    if (requestType == HttpRequestType.post) {
      return _sendPost(error);
    }
    return true;
  }

  Future<bool> _sendPost(Report error) async {
    try {
      var json = error.toJson();
      HashMap<String, dynamic> mutableHeaders = HashMap();
      if (headers != null) {
        mutableHeaders.addAll(headers);
      }
      Options options = Options(
          sendTimeout: requestTimeout,
          receiveTimeout: responseTimeout,
          headers: mutableHeaders);
      _printLog("Calling: ${endpointUri.toString()}");
      Response response =
          await _dio.post(endpointUri.toString(), data: json, options: options);
      _printLog(
          "HttpHandler response status: ${response.statusCode} body: ${response.data}");
      return SynchronousFuture(true);
    } catch (error, stackTrace) {
      _printLog("HttpHandler error: $error, stackTrace: $stackTrace");
      return SynchronousFuture(false);
    }
  }

  void _printLog(String log) {
    if (printLogs) {
      _logger.info(log);
    }
  }

  @override
  String toString() {
    return 'HttpHandler';
  }

  @override
  List<PlatformType> getSupportedPlatforms() =>
      [PlatformType.Web, PlatformType.Android, PlatformType.iOS];
}

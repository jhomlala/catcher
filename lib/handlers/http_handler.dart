import 'dart:collection';

import 'package:catcher/model/http_request_type.dart';
import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:catcher/model/report_handler.dart';
import 'package:catcher/utils/catcher_utils.dart';
import 'package:dio/dio.dart';
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
  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableStackTrace;
  final bool enableCustomParameters;

  HttpHandler(
    this.requestType,
    this.endpointUri, {
    Map<String, dynamic> headers,
    this.requestTimeout = 5000,
    this.responseTimeout = 5000,
    this.printLogs = false,
    this.enableDeviceParameters = true,
    this.enableApplicationParameters = true,
    this.enableStackTrace = true,
    this.enableCustomParameters = false,
  })  : assert(requestType != null, "requestType can't be null"),
        assert(endpointUri != null, "endpointUri can't be null"),
        assert(requestTimeout != null, "requestTimeout can't be null"),
        assert(responseTimeout != null, "responseTimeout can't be null"),
        assert(printLogs != null, "printLogs can't be null"),
        assert(enableDeviceParameters != null,
            "enableDeviceParameters can't be null"),
        assert(enableApplicationParameters != null,
            "enableApplicationParameters can't be null"),
        assert(enableStackTrace != null, "enableStackTrace can't be null"),
        assert(enableCustomParameters != null,
            "enableCustomParameters can't be null"),
        headers = headers ?? <String, dynamic>{};

  @override
  Future<bool> handle(Report error) async {
    if (error.platformType != PlatformType.web) {
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
      final json = error.toJson(
          enableDeviceParameters: enableDeviceParameters,
          enableApplicationParameters: enableApplicationParameters,
          enableStackTrace: enableStackTrace,
          enableCustomParameters: enableCustomParameters);
      final HashMap<String, dynamic> mutableHeaders =
          HashMap<String, dynamic>();
      if (headers != null) {
        mutableHeaders.addAll(headers);
      }
      final Options options = Options(
          sendTimeout: requestTimeout,
          receiveTimeout: responseTimeout,
          headers: mutableHeaders);
      _printLog("Calling: ${endpointUri.toString()}");
      final Response response = await _dio.post<dynamic>(endpointUri.toString(),
          data: json, options: options);
      _printLog(
          "HttpHandler response status: ${response.statusCode} body: ${response.data}");
      return true;
    } catch (error, stackTrace) {
      _printLog("HttpHandler error: $error, stackTrace: $stackTrace");
      return false;
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
      [PlatformType.web, PlatformType.android, PlatformType.iOS];
}

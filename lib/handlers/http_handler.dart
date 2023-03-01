import 'dart:collection';

import 'package:catcher/model/http_request_type.dart';
import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:catcher/model/report_handler.dart';
import 'package:catcher/utils/catcher_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HttpHandler extends ReportHandler {
  final Dio _dio = Dio();

  final HttpRequestType requestType;
  final Uri endpointUri;
  final Map<String, dynamic> headers;
  final Duration requestTimeout;
  final Duration responseTimeout;
  final bool printLogs;
  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableStackTrace;
  final bool enableCustomParameters;

  HttpHandler(
    this.requestType,
    this.endpointUri, {
    Map<String, dynamic>? headers,
    this.requestTimeout = const Duration(seconds: 5),
    this.responseTimeout = const Duration(seconds: 5),
    this.printLogs = false,
    this.enableDeviceParameters = true,
    this.enableApplicationParameters = true,
    this.enableStackTrace = true,
    this.enableCustomParameters = false,
  }) : headers = headers ?? <String, dynamic>{};

  @override
  Future<bool> handle(Report error, BuildContext? context) async {
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

  Future<bool> _sendPost(Report report) async {
    try {
      final json = report.toJson(
        enableDeviceParameters: enableDeviceParameters,
        enableApplicationParameters: enableApplicationParameters,
        enableStackTrace: enableStackTrace,
        enableCustomParameters: enableCustomParameters,
      );
      final HashMap<String, dynamic> mutableHeaders =
          HashMap<String, dynamic>();
      if (headers.isNotEmpty == true) {
        mutableHeaders.addAll(headers);
      }

      final Options options = Options(
        sendTimeout: requestTimeout,
        receiveTimeout: responseTimeout,
        headers: mutableHeaders,
      );

      Response? response;
      _printLog("Calling: ${endpointUri.toString()}");
      if (report.screenshot != null) {
        final screenshotPath = report.screenshot?.path ?? "";
        final FormData formData = FormData.fromMap(<String, dynamic>{
          "payload_json": json,
          "file": await MultipartFile.fromFile(screenshotPath)
        });
        response = await _dio.post<dynamic>(
          endpointUri.toString(),
          data: formData,
          options: options,
        );
      } else {
        response = await _dio.post<dynamic>(
          endpointUri.toString(),
          data: json,
          options: options,
        );
      }
      _printLog(
        "HttpHandler response status: ${response.statusCode!} body: ${response.data!}",
      );
      return true;
    } catch (error, stackTrace) {
      _printLog("HttpHandler error: $error, stackTrace: $stackTrace");
      return false;
    }
  }

  void _printLog(String log) {
    if (printLogs) {
      logger.info(log);
    }
  }

  @override
  String toString() {
    return 'HttpHandler';
  }

  @override
  List<PlatformType> getSupportedPlatforms() => [
        PlatformType.android,
        PlatformType.iOS,
        PlatformType.web,
        PlatformType.linux,
        PlatformType.macOS,
        PlatformType.windows,
      ];
}

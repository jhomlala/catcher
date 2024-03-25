import 'dart:collection';

import 'package:catcher_2/model/http_request_type.dart';
import 'package:catcher_2/model/platform_type.dart';
import 'package:catcher_2/model/report.dart';
import 'package:catcher_2/model/report_handler.dart';
import 'package:catcher_2/utils/catcher_2_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HttpHandler extends ReportHandler {
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

  @override
  Future<bool> handle(Report report, BuildContext? context) async {
    if (report.platformType != PlatformType.web &&
        !(await Catcher2Utils.isInternetConnectionAvailable())) {
      _printLog('No internet connection available');
      return false;
    }

    if (requestType == HttpRequestType.post) {
      return _sendPost(report);
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
      final mutableHeaders = HashMap<String, dynamic>();
      if (headers.isNotEmpty) {
        mutableHeaders.addAll(headers);
      }

      final options = Options(
        sendTimeout: requestTimeout,
        receiveTimeout: responseTimeout,
        headers: mutableHeaders,
      );

      Response<dynamic>? response;
      _printLog('Calling: $endpointUri');
      if (report.screenshot != null) {
        final screenshotPath = report.screenshot?.path ?? '';
        final formData = FormData.fromMap(<String, dynamic>{
          'payload_json': json,
          'file': await MultipartFile.fromFile(screenshotPath),
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
        'HttpHandler response status: ${response.statusCode!} '
        'body: ${response.data!}',
      );
      return true;
    } catch (error, stackTrace) {
      _printLog('HttpHandler error: $error, stackTrace: $stackTrace');
      return false;
    }
  }

  void _printLog(String log) {
    if (printLogs) {
      logger.info(log);
    }
  }

  @override
  String toString() => 'HttpHandler';

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

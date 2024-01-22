import 'dart:async';

import 'package:catcher_2/model/platform_type.dart';
import 'package:catcher_2/model/report.dart';
import 'package:catcher_2/model/report_handler.dart';
import 'package:catcher_2/utils/catcher_2_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// Slack webhook API doesn't allow file attachments
class SlackHandler extends ReportHandler {
  SlackHandler(
    this.webhookUrl,
    this.channel, {
    this.apiToken,
    this.username = 'Catcher 2',
    this.iconEmoji = ':bangbang:',
    this.printLogs = false,
    this.enableDeviceParameters = false,
    this.enableApplicationParameters = false,
    this.enableStackTrace = false,
    this.enableCustomParameters = false,
    this.customMessageBuilder,
  });

  final Dio _dio = Dio();

  final String webhookUrl;
  final String? apiToken;
  final String channel;
  final String username;
  final String iconEmoji;

  final bool printLogs;
  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableStackTrace;
  final bool enableCustomParameters;
  final FutureOr<String> Function(Report report)? customMessageBuilder;

  @override
  Future<bool> handle(Report report, BuildContext? context) async {
    try {
      if (!(await Catcher2Utils.isInternetConnectionAvailable())) {
        _printLog('No internet connection available');
        return false;
      }
      var message = '';
      if (customMessageBuilder != null) {
        message = await customMessageBuilder!(report);
      } else {
        message = _buildMessage(report);
      }

      final screenshot = report.screenshot;

      final data = <String, dynamic>{
        'text': message,
        'channel': channel,
        'username': username,
        'icon_emoji': iconEmoji,
      };
      _printLog('Sending request to Slack server...');

      if (apiToken != null && screenshot != null) {
        final screenshotPath = screenshot.path;
        final formData = FormData.fromMap(<String, dynamic>{
          'token': apiToken,
          'channels': channel,
          'file': await MultipartFile.fromFile(screenshotPath),
        });
        final responseFile = await _dio.post<dynamic>(
          'https://slack.com/api/files.upload',
          data: formData,
          options: Options(
            contentType: Headers.multipartFormDataContentType,
          ),
        );
        if (responseFile.data != null &&
            responseFile.data['file'] != null &&
            responseFile.data['file']['url_private'] != null) {
          data.addAll({
            'attachments': [
              {
                'image_url': responseFile.data['file']['url_private'],
                'text': 'Error Screenshot',
              },
            ],
          });
        }
        _printLog(
          'Server responded upload file with code: ${responseFile.statusCode} '
          'and message upload file: ${responseFile.statusMessage}',
        );
      }

      final response = await _dio.post<dynamic>(webhookUrl, data: data);
      _printLog(
        'Server responded with code: ${response.statusCode} and '
        'message: ${response.statusMessage}',
      );

      final statusCode = response.statusCode ?? 0;
      return statusCode >= 200 && statusCode < 300;
    } catch (exception) {
      _printLog('Failed to send slack message: $exception');
      return false;
    }
  }

  String _buildMessage(Report report) {
    final stringBuffer = StringBuffer()
      ..write('*Error:* ```${report.error}```\n');
    if (enableStackTrace) {
      stringBuffer.write('*Stack trace:* ```${report.stackTrace}```\n');
    }
    if (enableDeviceParameters && report.deviceParameters.isNotEmpty) {
      stringBuffer.write('*Device parameters:* ```');
      for (final entry in report.deviceParameters.entries) {
        stringBuffer.write('${entry.key}: ${entry.value}\n');
      }
      stringBuffer.write('```\n');
    }

    if (enableApplicationParameters &&
        report.applicationParameters.isNotEmpty) {
      stringBuffer.write('*Application parameters:* ```');
      for (final entry in report.applicationParameters.entries) {
        stringBuffer.write('${entry.key}: ${entry.value}\n');
      }
      stringBuffer.write('```\n');
    }

    if (enableCustomParameters && report.customParameters.isNotEmpty) {
      stringBuffer.write('*Custom parameters:* ```');
      for (final entry in report.customParameters.entries) {
        stringBuffer.write('${entry.key}: ${entry.value}\n');
      }
      stringBuffer.write('```\n');
    }
    return stringBuffer.toString();
  }

  void _printLog(String log) {
    if (printLogs) {
      logger.info(log);
    }
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

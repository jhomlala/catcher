import 'dart:async';

import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:catcher/model/report_handler.dart';
import 'package:catcher/utils/catcher_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

//Slack webhook API doesn't allow file attachments
class SlackHandler extends ReportHandler {
  final Dio _dio = Dio();

  final String webhookUrl;
  final String channel;
  final String username;
  final String iconEmoji;

  final bool printLogs;
  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableStackTrace;
  final bool enableCustomParameters;
  final FutureOr<String> Function(Report report)? customMessageBuilder;

  SlackHandler(
    this.webhookUrl,
    this.channel, {
    this.username = 'Catcher',
    this.iconEmoji = ':bangbang:',
    this.printLogs = false,
    this.enableDeviceParameters = false,
    this.enableApplicationParameters = false,
    this.enableStackTrace = false,
    this.enableCustomParameters = false,
    this.customMessageBuilder,
  });

  @override
  Future<bool> handle(Report report, BuildContext? context) async {
    try {
      if (!(await CatcherUtils.isInternetConnectionAvailable())) {
        _printLog('No internet connection available');
        return false;
      }
      var message = '';
      if (customMessageBuilder != null) {
        message = await customMessageBuilder!(report);
      } else {
        message = _buildMessage(report);
      }

      final data = {
        'text': message,
        'channel': channel,
        'username': username,
        'icon_emoji': iconEmoji,
      };
      _printLog('Sending request to Slack server...');
      final response = await _dio.post<dynamic>(webhookUrl, data: data);
      _printLog(
        'Server responded with code: ${response.statusCode} and message:'
        ' ${response.statusMessage}',
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

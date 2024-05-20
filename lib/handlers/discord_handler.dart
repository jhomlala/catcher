import 'dart:async';

import 'package:catcher_2/model/platform_type.dart';
import 'package:catcher_2/model/report.dart';
import 'package:catcher_2/model/report_handler.dart';
import 'package:catcher_2/utils/catcher_2_utils.dart';
import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DiscordHandler extends ReportHandler {
  DiscordHandler(
    this.webhookUrl, {
    this.printLogs = false,
    this.enableDeviceParameters = false,
    this.enableApplicationParameters = false,
    this.enableStackTrace = false,
    this.enableCustomParameters = false,
    this.customMessageBuilder,
  });

  final Dio _dio = Dio();

  final String webhookUrl;

  final bool printLogs;
  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableStackTrace;
  final bool enableCustomParameters;
  final FutureOr<String> Function(Report report)? customMessageBuilder;

  @override
  Future<bool> handle(Report report, BuildContext? context) async {
    if (report.platformType != PlatformType.web &&
        !(await Catcher2Utils.isInternetConnectionAvailable())) {
      _printLog('No internet connection available');
      return false;
    }

    var message = '';
    if (customMessageBuilder != null) {
      message = await customMessageBuilder!(report);
    } else {
      message = _buildMessage(report);
    }
    final messages = _setupMessages(message);

    for (final value in messages) {
      final isLastMessage = messages.indexOf(value) == messages.length - 1;
      final result =
          await _sendContent(value, isLastMessage ? report.screenshot : null);
      if (!result) {
        return result;
      }
    }

    return true;
  }

  List<String> _setupMessages(String message) {
    final messages = <String>[];
    final splits = (message.length / 2000).ceil();
    final messageLength = message.length;
    for (var index = 0; index < splits; index++) {
      final startIndex = index * 2000;
      var endIndex = startIndex + 2000;
      if (endIndex > messageLength) {
        endIndex = messageLength;
      }
      messages.add(message.substring(startIndex, endIndex));
    }
    return messages;
  }

  String _buildMessage(Report report) {
    final stringBuffer = StringBuffer()
      ..write('**Error:**\n${report.error}\n\n');
    if (enableStackTrace) {
      stringBuffer.write('**Stack trace:**\n${report.stackTrace}\n\n');
    }
    if (enableDeviceParameters && report.deviceParameters.isNotEmpty) {
      stringBuffer.write('**Device parameters:**\n');
      for (final entry in report.deviceParameters.entries) {
        stringBuffer.write('${entry.key}: ${entry.value}\n');
      }
      stringBuffer.write('\n\n');
    }

    if (enableApplicationParameters &&
        report.applicationParameters.isNotEmpty) {
      stringBuffer.write('**Application parameters:**\n');
      for (final entry in report.applicationParameters.entries) {
        stringBuffer.write('${entry.key}: ${entry.value}\n');
      }
      stringBuffer.write('\n\n');
    }

    if (enableCustomParameters && report.customParameters.isNotEmpty) {
      stringBuffer.write('**Custom parameters:**\n');
      for (final entry in report.customParameters.entries) {
        stringBuffer.write('${entry.key}: ${entry.value}\n');
      }
      stringBuffer.write('\n\n');
    }
    return stringBuffer.toString();
  }

  Future<bool> _sendContent(String content, XFile? screenshot) async {
    try {
      _printLog('Sending request to Discord server...');
      Response<dynamic>? response;

      final data = <String, dynamic>{
        'content': content,
      };

      if (screenshot != null) {
        data.addAll(
          {
            'file': MultipartFile.fromBytes(
              await screenshot.readAsBytes(),
              filename: screenshot.name,
            ),
          },
        );
      }

      response = await _dio.post<dynamic>(
        webhookUrl,
        data: FormData.fromMap(data),
      );

      _printLog(
        'Server responded with code: ${response.statusCode} and message: '
        '${response.statusMessage}',
      );
      return response.ok;
    } catch (exception) {
      _printLog('Failed to send data to Discord server: $exception');
      return false;
    }
  }

  void _printLog(String log) {
    if (printLogs) {
      logger.info(log);
    }
  }

  @override
  List<PlatformType> getSupportedPlatforms() => [
        PlatformType.web,
        PlatformType.android,
        PlatformType.iOS,
        PlatformType.linux,
        PlatformType.macOS,
        PlatformType.windows,
      ];
}

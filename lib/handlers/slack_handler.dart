import 'dart:async';
import 'dart:convert';

import 'package:catcher_2/model/platform_type.dart';
import 'package:catcher_2/model/report.dart';
import 'package:catcher_2/model/report_handler.dart';
import 'package:catcher_2/utils/catcher_2_utils.dart';
import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SlackHandler extends ReportHandler {
  SlackHandler(
    this.webhookUrl,
    this.channel, {
    this.apiToken,
    this.channelId,
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
  final String? channelId;
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

      if (screenshot != null) {
        data.addAll(
          await _tryUploadScreenshot(screenshot: screenshot),
        );
      }

      final response = await _dio.post<dynamic>(
        webhookUrl,
        data: json.encode(data),
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      _printLog(
        'Server responded with code: ${response.statusCode} and '
        'message: ${response.statusMessage}',
      );

      return response.ok;
    } catch (exception) {
      _printLog('Failed to send slack message: $exception');
      return false;
    }
  }

  Future<Map<String, dynamic>> _tryUploadScreenshot({
    required XFile screenshot,
  }) async {
    if (apiToken == null || channelId == null) {
      _printLog(
        'Cannot send screenshot to Slack because either '
        'apiToken or channelId is not set!',
      );
      return {};
    }

    try {
      final name = screenshot.name;

      final formData = FormData.fromMap(<String, dynamic>{
        'token': apiToken,
        'filename': name,
        'length': await screenshot.length(),
        'alt_txt': 'Error Screenshot',
      });
      final responseFile = await _dio.post<dynamic>(
        'https://slack.com/api/files.getUploadURLExternal',
        data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
      if (responseFile.data == null ||
          responseFile.data['ok'] != true ||
          responseFile.data['upload_url'] == null ||
          responseFile.data['file_id'] == null) {
        _printLog(
          'Server responded to getUploadURLExternal with code: '
          '${responseFile.statusCode} '
          'and message upload file: ${responseFile.statusMessage}',
        );
        return {};
      }

      final formDataPost = FormData.fromMap(<String, dynamic>{
        'token': apiToken,
        'file': MultipartFile.fromBytes(
          await screenshot.readAsBytes(),
          filename: screenshot.name,
        ),
      });
      final responseFilePost = await _dio.post<dynamic>(
        responseFile.data['upload_url'],
        data: formDataPost,
        options: Options(
          contentType: Headers.multipartFormDataContentType,
          validateStatus: (e) => true,
        ),
      );
      if (!responseFilePost.ok) {
        _printLog(
          'Server responded to upload file post with code: '
          '${responseFilePost.statusCode} '
          'and message upload file: ${responseFilePost.statusMessage}',
        );
        return {};
      }

      final formDataComplete = FormData.fromMap(<String, dynamic>{
        'token': apiToken,
        'files': '[{"id":"${responseFile.data['file_id']}"}]',
        'channel_id': channelId,
      });
      final responseFileComplete = await _dio.post<dynamic>(
        'https://slack.com/api/files.completeUploadExternal',
        data: formDataComplete,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      _printLog(
        'Server responded to completeUploadExternal with code: '
        '${responseFileComplete.statusCode} '
        'and message upload file: ${responseFileComplete.statusMessage}',
      );

      if (responseFileComplete.data == null ||
          responseFileComplete.data['ok'] != true) {
        return {};
      }

      return {
        'attachments': [
          {
            'image_url': responseFileComplete.data['files'][0]['url_private'],
            'text': 'Screenshot will soon be available here: '
                '${responseFileComplete.data['files'][0]['permalink']}',
          },
        ],
      };
    } catch (exception) {
      _printLog('Failed to send screenshot: $exception');
      return {};
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

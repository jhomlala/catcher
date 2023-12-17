import 'package:catcher_2/model/platform_type.dart';
import 'package:catcher_2/model/report.dart';
import 'package:catcher_2/model/report_handler.dart';
import 'package:flutter/material.dart';

class ConsoleHandler extends ReportHandler {
  ConsoleHandler({
    this.enableDeviceParameters = true,
    this.enableApplicationParameters = true,
    this.enableStackTrace = true,
    this.enableCustomParameters = false,
    this.handleWhenRejected = false,
  });

  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableStackTrace;
  final bool enableCustomParameters;
  final bool handleWhenRejected;

  @override
  Future<bool> handle(Report report, BuildContext? context) {
    logger
      ..info(
        '============================== '
        'CATCHER 2 LOG '
        '==============================',
      )
      ..info('Crash occurred on ${report.dateTime}')
      ..info('');
    if (enableDeviceParameters) {
      _printDeviceParametersFormatted(report.deviceParameters);
      logger.info('');
    }
    if (enableApplicationParameters) {
      _printApplicationParametersFormatted(report.applicationParameters);
      logger.info('');
    }
    logger
      ..info('---------- ERROR ----------')
      ..info('${report.error}')
      ..info('');
    if (enableStackTrace) {
      _printStackTraceFormatted(report.stackTrace);
    }
    if (enableCustomParameters) {
      _printCustomParametersFormatted(report.customParameters);
    }
    logger.info(
      '======================================================================',
    );
    return Future.value(true);
  }

  void _printDeviceParametersFormatted(Map<String, dynamic> deviceParameters) {
    logger.info('------- DEVICE INFO -------');
    for (final entry in deviceParameters.entries) {
      logger.info('${entry.key}: ${entry.value}');
    }
  }

  void _printApplicationParametersFormatted(
    Map<String, dynamic> applicationParameters,
  ) {
    logger.info('------- APP INFO -------');
    for (final entry in applicationParameters.entries) {
      logger.info('${entry.key}: ${entry.value}');
    }
  }

  void _printCustomParametersFormatted(Map<String, dynamic> customParameters) {
    logger.info('------- CUSTOM INFO -------');
    for (final entry in customParameters.entries) {
      logger.info('${entry.key}: ${entry.value}');
    }
  }

  void _printStackTraceFormatted(stackTrace) {
    logger.info('------- STACK TRACE -------');
    stackTrace?.toString().split('\n').forEach((entry) => logger.info(entry));
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

  @override
  bool shouldHandleWhenRejected() => handleWhenRejected;
}

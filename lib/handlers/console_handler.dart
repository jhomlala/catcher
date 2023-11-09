import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:catcher/model/report_handler.dart';
import 'package:flutter/material.dart';

class ConsoleHandler extends ReportHandler {
  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableStackTrace;
  final bool enableCustomParameters;
  final bool handleWhenRejected;

  ConsoleHandler({
    this.enableDeviceParameters = true,
    this.enableApplicationParameters = true,
    this.enableStackTrace = true,
    this.enableCustomParameters = false,
    this.handleWhenRejected = false,
  });

  @override
  Future<bool> handle(Report report, BuildContext? context) {
    logger
      ..info(
        '============================ CATCHER LOG ============================',
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
      _printStackTraceFormatted(report.stackTrace as StackTrace?);
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

  void _printStackTraceFormatted(StackTrace? stackTrace) {
    logger.info('------- STACK TRACE -------');
    for (final entry in stackTrace.toString().split('\n')) {
      logger.info(entry);
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

  @override
  bool shouldHandleWhenRejected() {
    return handleWhenRejected;
  }
}

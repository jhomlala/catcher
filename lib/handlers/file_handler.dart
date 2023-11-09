import 'dart:convert';
import 'dart:io';

import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:catcher/model/report_handler.dart';
import 'package:flutter/material.dart';

class FileHandler extends ReportHandler {
  final File file;
  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableStackTrace;
  final bool enableCustomParameters;
  final bool printLogs;
  final bool handleWhenRejected;

  late IOSink _sink;
  bool _fileValidated = false;
  bool _fileValidationResult = false;

  FileHandler(
    this.file, {
    this.enableDeviceParameters = true,
    this.enableApplicationParameters = true,
    this.enableStackTrace = true,
    this.enableCustomParameters = true,
    this.printLogs = false,
    this.handleWhenRejected = false,
  });

  @override
  Future<bool> handle(Report report, BuildContext? context) async {
    try {
      if (!_fileValidated) {
        _fileValidationResult = await _checkFile();
        _fileValidated = true;
      }
      return await _processReport(report);
    } catch (exc, stackTrace) {
      _printLog('Exception occurred: $exc stack: $stackTrace');
      return false;
    }
  }

  Future<bool> _processReport(Report report) async {
    if (_fileValidationResult) {
      await _openFile();
      await _writeReportToFile(report);
      await _closeFile();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _checkFile() async {
    try {
      final exists = file.existsSync();
      if (!exists) {
        file.createSync();
      }
      final sink = file.openWrite(mode: FileMode.append)..write('');
      await sink.flush();
      await sink.close();
      return true;
    } catch (exc, stackTrace) {
      _printLog('Exception occurred: $exc stack: $stackTrace');
      return false;
    }
  }

  Future<void> _openFile() async {
    _sink = file.openWrite(mode: FileMode.append);
    _printLog('Opened file');
  }

  void _writeLineToFile(String text) {
    _sink.add(utf8.encode('$text\n'));
  }

  Future<void> _closeFile() async {
    await _sink.flush();
    await _sink.close();
    _printLog('Closed file');
  }

  Future<void> _writeReportToFile(Report report) async {
    _printLog('Writing report to file');
    _writeLineToFile(
      '============================ CATCHER LOG ============================',
    );
    _writeLineToFile('Crash occurred on ${report.dateTime}');
    _writeLineToFile('');
    if (enableDeviceParameters) {
      _logDeviceParametersFormatted(report.deviceParameters);
      _writeLineToFile('');
    }
    if (enableApplicationParameters) {
      _logApplicationParametersFormatted(report.applicationParameters);
      _writeLineToFile('');
    }
    _writeLineToFile('---------- ERROR ----------');
    _writeLineToFile('${report.error}');
    _writeLineToFile('');
    if (enableStackTrace) {
      _writeLineToFile('------- STACK TRACE -------');
      _writeLineToFile('${report.stackTrace}');
    }
    if (enableCustomParameters) {
      _logCustomParametersFormatted(report.customParameters);
    }
    _writeLineToFile(
      '======================================================================',
    );
  }

  void _logDeviceParametersFormatted(Map<String, dynamic> deviceParameters) {
    _writeLineToFile('------- DEVICE INFO -------');
    for (final entry in deviceParameters.entries) {
      _writeLineToFile('${entry.key}: ${entry.value}');
    }
  }

  void _logApplicationParametersFormatted(
    Map<String, dynamic> applicationParameters,
  ) {
    _writeLineToFile('------- APP INFO -------');
    for (final entry in applicationParameters.entries) {
      _writeLineToFile('${entry.key}: ${entry.value}');
    }
  }

  void _logCustomParametersFormatted(Map<String, dynamic> customParameters) {
    _writeLineToFile('------- CUSTOM INFO -------');
    for (final entry in customParameters.entries) {
      _writeLineToFile('${entry.key}: ${entry.value}');
    }
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
        PlatformType.linux,
        PlatformType.macOS,
        PlatformType.windows,
      ];

  @override
  bool shouldHandleWhenRejected() {
    return handleWhenRejected;
  }
}

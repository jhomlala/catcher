import 'dart:convert';
import 'dart:io';

import 'package:catcher/model/report.dart';
import 'package:catcher/handlers/report_handler.dart';
import 'package:logging/logging.dart';

class FileHandler extends ReportHandler {
  final File file;
  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableStackTrace;
  final bool enableCustomParameters;
  final bool printLogs;

  final Logger _logger = Logger("FileHandler");
  IOSink _sink;
  bool _fileValidated = false;
  bool _fileValidationResult = false;

  FileHandler(this.file,
      {this.enableDeviceParameters = true,
      this.enableApplicationParameters = true,
      this.enableStackTrace = true,
      this.enableCustomParameters = true,
      this.printLogs = false})
      : assert(file != null, "File can't be null"),
        assert(enableDeviceParameters != null,
            "enableDeviceParameters can't be null"),
        assert(enableApplicationParameters != null,
            "enableApplicationParameters can't be null"),
        assert(enableStackTrace != null, "enableStackTrace can't be null"),
        assert(enableCustomParameters != null,
            "enableCustomParameters can't be null"),
        assert(printLogs != null, "printLogs can't be null");

  @override
  Future<bool> handle(Report report) async {
    try {
      if (!_fileValidated) {
        _fileValidationResult = await _checkFile();
        _fileValidated = true;
      }
      return await _processReport(report);
    } catch (exc, stackTrace) {
      _printLog("Exception occured: $exc stack: $stackTrace");
      return false;
    }
  }

  Future<bool> _processReport(Report report) async {
    if (_fileValidationResult) {
      await _openFile();
      _writeReportToFile(report);
      await _closeFile();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _checkFile() async {
    try {
      bool exists = await file.exists();
      if (!exists) {
        file.createSync();
      }
      IOSink sink = file.openWrite(mode: FileMode.append);
      sink.write("");
      await sink.flush();
      await sink.close();
      return true;
    } catch (exc, stackTrace) {
      _printLog("Exception occured: $exc stack: $stackTrace");
      return false;
    }
  }

  Future _openFile() async {
    _sink = file.openWrite(mode: FileMode.append);
    _printLog("Opened file");
  }

  void _writeLineToFile(String text) {
    _sink.add(utf8.encode('$text\n'));
  }

  Future _closeFile() async {
    await _sink.flush();
    await _sink.close();
    _printLog("Closed file");
  }

  void _writeReportToFile(Report report) async {
    _printLog("Writing report to file");
    _writeLineToFile(
        "============================== CATCHER LOG ==============================");
    _writeLineToFile("Crash occured on ${report.dateTime}");
    _writeLineToFile("");
    if (enableDeviceParameters) {
      _logDeviceParametersFormatted(report.deviceParameters);
      _writeLineToFile("");
    }
    if (enableApplicationParameters) {
      _logApplicationParametersFormatted(report.applicationParameters);
      _writeLineToFile("");
    }
    _writeLineToFile("---------- ERROR ----------");
    _writeLineToFile("${report.error}");
    _writeLineToFile("");
    if (enableStackTrace) {
      _writeLineToFile("------- STACK TRACE -------");
      _writeLineToFile("${report.stackTrace}");
    }
    if (enableCustomParameters) {
      _logCustomParametersFormatted(report.customParameters);
    }
    _writeLineToFile(
        "======================================================================");
  }

  void _logDeviceParametersFormatted(Map<String, dynamic> deviceParameters) {
    _writeLineToFile("------- DEVICE INFO -------");
    for (var entry in deviceParameters.entries) {
      _writeLineToFile("${entry.key}: ${entry.value}");
    }
  }

  void _logApplicationParametersFormatted(
      Map<String, dynamic> applicationParameters) {
    _writeLineToFile("------- APP INFO -------");
    for (var entry in applicationParameters.entries) {
      _writeLineToFile("${entry.key}: ${entry.value}");
    }
  }

  void _logCustomParametersFormatted(Map<String, dynamic> customParameters) {
    _writeLineToFile("------- CUSTOM INFO -------");
    for (var entry in customParameters.entries) {
      _writeLineToFile("${entry.key}: ${entry.value}");
    }
  }

  void _printLog(String log) {
    if (printLogs) {
      _logger.info(log);
    }
  }
}

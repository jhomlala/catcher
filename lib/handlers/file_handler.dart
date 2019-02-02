import 'dart:convert';
import 'dart:io';

import 'package:catcher/model/report.dart';
import 'package:catcher/handlers/report_handler.dart';

class FileHandler extends ReportHandler {
  final File file;
  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableStackTrace;
  final bool enableCustomParameters;
  final bool printLogs;
  IOSink _sink;

  FileHandler(this.file,
      {this.enableDeviceParameters = true,
      this.enableApplicationParameters = true,
      this.enableStackTrace = true,
      this.enableCustomParameters = true,
      this.printLogs = false});

  @override
  Future<bool> handle(Report report) async {
    bool fileValidation = await _checkFile();
    _printLog("File validation: $fileValidation");
    if (fileValidation) {
      _openFile();
      _writeReportToFile(report);
      _closeFile();
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
      sink.flush();
      sink.close();
      return true;
    } catch (exc, stackTrace) {
      print(exc + " " + stackTrace);
      return false;
    }
  }

  _openFile() {
    _sink = file.openWrite(mode: FileMode.append);
    _printLog("Opened file");
  }

  _writeLineToFile(String text) {
    _sink.add(utf8.encode('$text\n'));
  }

  _closeFile() async {
    await _sink.flush();
    await _sink.close();
    _printLog("Closed file");
  }

  _writeReportToFile(Report report) async {
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

  _logDeviceParametersFormatted(Map<String, dynamic> deviceParameters) {
    _writeLineToFile("------- DEVICE INFO -------");
    for (var entry in deviceParameters.entries) {
      _writeLineToFile("${entry.key}: ${entry.value}");
    }
  }

  _logApplicationParametersFormatted(
      Map<String, dynamic> applicationParameters) {
    _writeLineToFile("------- APP INFO -------");
    for (var entry in applicationParameters.entries) {
      _writeLineToFile("${entry.key}: ${entry.value}");
    }
  }

  _logCustomParametersFormatted(Map<String, dynamic> customParameters) {
    _writeLineToFile("------- CUSTOM INFO -------");
    for (var entry in customParameters.entries) {
      _writeLineToFile("${entry.key}: ${entry.value}");
    }
  }

  _printLog(String log) {
    if (printLogs) {
      print(log);
    }
  }
}

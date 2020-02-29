import 'package:flutter/material.dart';

class Report {
  final dynamic error;
  final dynamic stackTrace;
  final DateTime dateTime;
  final Map<String, dynamic> deviceParameters;
  final Map<String, dynamic> applicationParameters;
  final Map<String, dynamic> customParameters;
  final FlutterErrorDetails errorDetails;

  Report(this.error, this.stackTrace, this.dateTime, this.deviceParameters,
      this.applicationParameters, this.customParameters, this.errorDetails);

  Map<String, dynamic> toJson() => {
        "error": error.toString(),
        "stackTrace": stackTrace.toString(),
        "deviceParameters": deviceParameters,
        "applicationParameters": applicationParameters,
        "customParameters": customParameters,
        "dateTime": dateTime.toIso8601String()
      };
}

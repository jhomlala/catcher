import 'package:catcher/model/platform_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Report {
  final dynamic error;
  final dynamic stackTrace;
  final DateTime dateTime;
  final Map<String, dynamic> deviceParameters;
  final Map<String, dynamic> applicationParameters;
  final Map<String, dynamic> customParameters;
  final FlutterErrorDetails errorDetails;
  final PlatformType platformType;

  Report(
      this.error,
      this.stackTrace,
      this.dateTime,
      this.deviceParameters,
      this.applicationParameters,
      this.customParameters,
      this.errorDetails,
      this.platformType);

  Map<String, dynamic> toJson() => {
        "error": error.toString(),
        "stackTrace": stackTrace.toString(),
        "deviceParameters": deviceParameters,
        "applicationParameters": applicationParameters,
        "customParameters": customParameters,
        "dateTime": dateTime.toIso8601String(),
        "platformType": describeEnum(platformType),
      };
}

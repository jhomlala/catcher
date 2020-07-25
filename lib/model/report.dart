import 'package:catcher/model/platform_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Report {
  /// Error that has been catched
  final dynamic error;

  /// Stack trace of error
  final dynamic stackTrace;

  /// Time when it was catched
  final DateTime dateTime;

  /// Device info
  final Map<String, dynamic> deviceParameters;

  /// Application info
  final Map<String, dynamic> applicationParameters;

  /// Custom parameters passed to report
  final Map<String, dynamic> customParameters;

  /// FlutterErrorDetails data if present
  final FlutterErrorDetails errorDetails;

  /// Type of platform used
  final PlatformType platformType;

  /// Creates report instance
  Report(
      this.error,
      this.stackTrace,
      this.dateTime,
      this.deviceParameters,
      this.applicationParameters,
      this.customParameters,
      this.errorDetails,
      this.platformType);

  /// Creates json from current instance
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

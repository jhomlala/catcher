import 'dart:io';

import 'package:catcher/model/platform_type.dart';
import 'package:flutter/foundation.dart';

class Report {
  /// Error that has been caught
  final dynamic error;

  /// Stack trace of error
  final dynamic stackTrace;

  /// Time when it was caught
  final DateTime dateTime;

  /// Device info
  final Map<String, dynamic> deviceParameters;

  /// Application info
  final Map<String, dynamic> applicationParameters;

  /// Custom parameters passed to report
  final Map<String, dynamic> customParameters;

  /// FlutterErrorDetails data if present
  final FlutterErrorDetails? errorDetails;

  /// Type of platform used
  final PlatformType platformType;

  ///Screenshot of screen where error happens. Screenshot won't work everywhere
  /// (i.e. web platform), so this may be null.
  final File? screenshot;

  /// Creates report instance
  Report(
    this.error,
    this.stackTrace,
    this.dateTime,
    this.deviceParameters,
    this.applicationParameters,
    this.customParameters,
    this.errorDetails,
    this.platformType,
    this.screenshot,
  );

  /// Creates json from current instance
  Map<String, dynamic> toJson({
    bool enableDeviceParameters = true,
    bool enableApplicationParameters = true,
    bool enableStackTrace = true,
    bool enableCustomParameters = false,
  }) {
    final json = <String, dynamic>{
      'error': error.toString(),
      'customParameters': customParameters,
      'dateTime': dateTime.toIso8601String(),
      'platformType': describeEnum(platformType),
    };
    if (enableDeviceParameters) {
      json['deviceParameters'] = deviceParameters;
    }
    if (enableApplicationParameters) {
      json['applicationParameters'] = applicationParameters;
    }
    if (enableStackTrace) {
      json['stackTrace'] = stackTrace.toString();
    }
    if (enableCustomParameters) {
      json['customParameters'] = customParameters;
    }
    return json;
  }
}

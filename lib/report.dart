class Report {
  final dynamic error;
  final StackTrace stackTrace;
  final Map<String, dynamic> deviceParameters;
  final Map<String, dynamic> applicationParameters;

  Report(this.error, this.stackTrace, this.deviceParameters,
      this.applicationParameters);

  Map<String, dynamic> toJson() => {
        "error": error.toString(),
        "stackTrace": stackTrace.toString(),
        "deviceParameters": deviceParameters,
        "applicationParameters": applicationParameters
      };
}

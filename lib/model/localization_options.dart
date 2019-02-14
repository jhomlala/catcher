class LocalizationOptions {
  final String languageCode;
  final String notificationReportModeTitle;
  final String notificationReportModeContent;

  LocalizationOptions(this.languageCode,
      {this.notificationReportModeTitle = "Application error occurred",
        this.notificationReportModeContent =
        "Click here to send error report to support team."});

  LocalizationOptions.buildDefault(
      {this.notificationReportModeTitle = "Application error occurred",
        this.notificationReportModeContent =
        "Click here to send error report to support team."})
      : languageCode = "en";


  @override
  String toString() {
    return 'LocalizationOptions{languageCode: $languageCode, notificationReportModeTitle: $notificationReportModeTitle, notificationReportModeContent: $notificationReportModeContent}';
  }
}

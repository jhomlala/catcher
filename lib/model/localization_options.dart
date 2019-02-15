class LocalizationOptions {
  final String languageCode;
  final String notificationReportModeTitle;
  final String notificationReportModeContent;

  final String dialogReportModeTitle;
  final String dialogReportModeDescription;
  final String dialogReportModeAccept;
  final String dialogReportModeCancel;

  final String pageReportModeTitle;
  final String pageReportModeDescription;
  final String pageReportModeAccept;
  final String pageReportModeCancel;
  
  LocalizationOptions(
    this.languageCode, {
    this.notificationReportModeTitle = "Application error occurred",
    this.notificationReportModeContent =
        "Click here to send error report to support team.",
    this.dialogReportModeTitle = "Crash",
    this.dialogReportModeDescription =
        "Unexpected error occurred in application. Error report is ready to send to support team. Please click Accept to send error report or Cancel to dismiss report.",
    this.dialogReportModeAccept = "Accept",
    this.dialogReportModeCancel = "Cancel",
    this.pageReportModeTitle = "Crash",
    this.pageReportModeDescription =
        "Unexpected error occurred in application. Error report is ready to send to support team. Please click Accept to send error report or Cancel to dismiss report.",
    this.pageReportModeAccept = "Accept",
    this.pageReportModeCancel = "Cancel",
  });

  static LocalizationOptions buildDefault() {
    return LocalizationOptions("en");
  }

  @override
  String toString() {
    return 'LocalizationOptions{languageCode: $languageCode, notificationReportModeTitle: $notificationReportModeTitle, notificationReportModeContent: $notificationReportModeContent}';
  }
}

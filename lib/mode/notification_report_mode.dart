import 'package:catcher/model/report_mode.dart';
import 'package:catcher/model/report.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationReportMode extends ReportMode {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  Report _lastReport;

  final String notificationTitle;
  final String notificationContent;
  final String notificationChannelId;
  final String notificationChannelName;
  final String notificationChannelDescription;
  final String notificationIcon;

  NotificationReportMode(
      {this.notificationTitle = "Application error occurred",
      this.notificationContent = "Click here to send error report",
      this.notificationChannelId = "Catcher",
      this.notificationChannelName = "Catcher",
      this.notificationChannelDescription = "Catcher default channel",
      this.notificationIcon = "@mipmap/ic_launcher"}) {
    _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings(notificationIcon);
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectedNotification);
  }

  @override
  void requestAction(Report report, BuildContext context) {
    _lastReport = report;
    _sendNotification();
  }

  Future onSelectedNotification(String payload) {
    onActionConfirmed(_lastReport);
    return Future.value(null);
  }

  void _sendNotification() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        notificationChannelId,
        notificationChannelName,
        notificationChannelDescription,
        importance: Importance.Default,
        priority: Priority.Default);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
        0, notificationTitle, notificationContent, platformChannelSpecifics,
        payload: "");
  }
}

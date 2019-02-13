import 'package:catcher/model/report_mode.dart';
import 'package:catcher/model/report.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationReportMode extends ReportMode {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  Report _lastReport;

  final String titleText;
  final String contentText;
  final String channelId;
  final String channelName;
  final String channelDescription;
  final String icon;

  NotificationReportMode(
      {this.titleText = "Application error occurred",
      this.contentText = "Click here to send error report to support team.",
      this.channelId = "Catcher",
      this.channelName = "Catcher",
      this.channelDescription = "Catcher default channel",
      this.icon = "@mipmap/ic_launcher"}) {
    _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = new AndroidInitializationSettings(icon);
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
        channelId, channelName, channelDescription,
        importance: Importance.Default, priority: Priority.Default);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin
        .show(0, titleText, contentText, platformChannelSpecifics, payload: "");
  }
}

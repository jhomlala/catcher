import 'package:catcher/model/report_mode.dart';
import 'package:catcher/model/report.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';

class NotificationReportMode extends ReportMode {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  Report _lastReport;

  NotificationReportMode() {
    _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings("@mipmap/ic_launcher");
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
        'CATCHER', 'Catcher', 'Catcher error handler',
        importance: Importance.Default, priority: Priority.Default);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
        0,
        "We have detected unexpected crash.",
        "Click here to send crash logs.",
        platformChannelSpecifics,
        payload: "");
  }
}

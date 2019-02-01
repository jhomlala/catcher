import 'package:catcher/mode/report_mode.dart';
import 'package:catcher/mode/report_mode_action_confirmed.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationReportMode extends ReportMode{
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  NotificationReportMode(ReportModeAction reportModeAction) : super(reportModeAction){
    _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = new AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectedNotification);
  }

  @override
  void requestAction() {
    _sendNotification();
  }


  Future onSelectedNotification(String payload) {
    onActionConfirmed();
    return Future.value(null);
  }

  void _sendNotification() async{
    print("Sending notification");
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'CATCHER', 'Catcher', 'Catcher error handler',
        importance: Importance.Default, priority: Priority.Default);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);


    await _flutterLocalNotificationsPlugin.show(
        0, "Crash", "We have detected unexpected crash of application. Click here to send crash logs.", platformChannelSpecifics,
        payload: "");
  }
}
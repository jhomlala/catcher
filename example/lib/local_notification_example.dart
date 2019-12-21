import 'package:catcher/mode/report_mode_action_confirmed.dart';
import 'package:catcher/model/localization_options.dart';
import 'package:catcher/model/report_mode.dart';
import 'package:catcher/model/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:catcher/catcher_plugin.dart';

main() {
  CatcherOptions debugOptions = CatcherOptions(NotificationReportMode(), [
    EmailManualHandler(["recipient@email.com"]),
    ConsoleHandler()
  ]);
  CatcherOptions releaseOptions = CatcherOptions(PageReportMode(), [
    EmailManualHandler(["recipient@email.com"])
  ]);

  Catcher(MyApp(), debugConfig: debugOptions, releaseConfig: releaseOptions);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Catcher.navigatorKey,
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: ChildWidget()),
    );
  }
}

class ChildWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: FlatButton(
            child: Text("Generate error"), onPressed: () => generateError()));
  }

  generateError() async {
    Catcher.sendTestException();
  }
}

class NotificationReportMode extends ReportMode {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  Report _lastReport;

  final String channelId;
  final String channelName;
  final String channelDescription;
  final String icon;

  NotificationReportMode(
      {this.channelId = "Catcher",
        this.channelName = "Catcher",
        this.channelDescription = "Catcher default channel",
        this.icon = "@mipmap/ic_launcher"});

  @override
  initialize(ReportModeAction reportModeAction,
      LocalizationOptions localizationOptions) {
    _initializeNotificationsPlugin();
    return super.initialize(reportModeAction, localizationOptions);
  }

  /// We need to init notifications plugin after constructor. If we init
  /// in constructor, and there will be 2 catcher options which uses this report
  /// mode, only notification report mode from second catcher options will be
  /// initialized correctly. That's why init is delayed.
  void _initializeNotificationsPlugin() {
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

    await _flutterLocalNotificationsPlugin.show(
        0,
        localizationOptions.notificationReportModeTitle,
        localizationOptions.notificationReportModeContent,
        platformChannelSpecifics,
        payload: "");
  }
}

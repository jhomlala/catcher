import 'package:catcher/catcher.dart';
import 'package:catcher/model/platform_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  CatcherOptions debugOptions = CatcherOptions(NotificationReportMode(), [
    EmailManualHandler(["recipient@email.com"]),
    ConsoleHandler()
  ]);
  CatcherOptions releaseOptions = CatcherOptions(PageReportMode(), [
    EmailManualHandler(["recipient@email.com"])
  ]);

  Catcher(
    rootWidget: MyApp(),
    debugConfig: debugOptions,
    releaseConfig: releaseOptions,
  );
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
        body: ChildWidget(),
      ),
    );
  }
}

class ChildWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextButton(
            child: Text("Generate error"), onPressed: () => generateError()));
  }

  void generateError() async {
    Catcher.sendTestException();
  }
}

class NotificationReportMode extends ReportMode {
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  late Report _lastReport;

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
  setReportModeAction(ReportModeAction reportModeAction) {
    _initializeNotificationsPlugin();
    return super.setReportModeAction(reportModeAction);
  }

  /// We need to init notifications plugin after constructor. If we init
  /// in constructor, and there will be 2 catcher options which uses this report
  /// mode, only notification report mode from second catcher options will be
  /// initialized correctly. That's why init is delayed.
  void _initializeNotificationsPlugin() {
    _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = new AndroidInitializationSettings(icon);
    var initializationSettingsIOS = new DarwinInitializationSettings();
    var initializationSettings = new InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onSelectedNotification);
  }

  @override
  void requestAction(Report report, BuildContext? context) {
    _lastReport = report;
    _sendNotification();
  }

  Future onSelectedNotification(NotificationResponse details) {
    onActionConfirmed(_lastReport);
    return Future<int>.value(0);
  }

  void _sendNotification() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        channelId, channelName,
        channelDescription: channelDescription,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority);
    var iOSPlatformChannelSpecifics = new DarwinNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
        0,
        localizationOptions.notificationReportModeTitle,
        localizationOptions.notificationReportModeContent,
        platformChannelSpecifics,
        payload: "");
  }

  @override
  List<PlatformType> getSupportedPlatforms() =>
      [PlatformType.android, PlatformType.iOS];
}

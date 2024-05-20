import 'package:catcher_2/catcher_2.dart';
import 'package:catcher_2/model/platform_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  final debugOptions = Catcher2Options(NotificationReportMode(), [
    EmailManualHandler(['recipient@email.com']),
    ConsoleHandler(),
  ]);
  final releaseOptions = Catcher2Options(PageReportMode(), [
    EmailManualHandler(['recipient@email.com']),
  ]);

  Catcher2(
    rootWidget: const MyApp(),
    debugConfig: debugOptions,
    releaseConfig: releaseOptions,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        navigatorKey: Catcher2.navigatorKey,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: const ChildWidget(),
        ),
      );
}

class ChildWidget extends StatelessWidget {
  const ChildWidget({super.key});

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: generateError,
        child: const Text('Generate error'),
      );

  Future<void> generateError() async {
    Catcher2.sendTestException();
  }
}

class NotificationReportMode extends ReportMode {
  NotificationReportMode({
    this.channelId = 'Catcher 2',
    this.channelName = 'Catcher 2',
    this.channelDescription = 'Catcher 2 default channel',
    this.icon = '@mipmap/ic_launcher',
  });
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  late Report _lastReport;

  final String channelId;
  final String channelName;
  final String channelDescription;
  final String icon;

  @override
  set reportModeAction(ReportModeAction reportModeAction) {
    _initializeNotificationsPlugin();
    super.reportModeAction = reportModeAction;
  }

  /// We need to init notifications plugin after constructor. If we init
  /// in constructor, and there will be 2 catcher options which uses this report
  /// mode, only notification report mode from second catcher options will be
  /// initialized correctly. That's why init is delayed.
  void _initializeNotificationsPlugin() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initializationSettingsAndroid = AndroidInitializationSettings(icon);
    const initializationSettingsIOS = DarwinInitializationSettings();
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onSelectedNotification,
    );
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

  Future<void> _sendNotification() async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      localizationOptions.notificationReportModeTitle,
      localizationOptions.notificationReportModeContent,
      platformChannelSpecifics,
      payload: '',
    );
  }

  @override
  List<PlatformType> getSupportedPlatforms() =>
      [PlatformType.android, PlatformType.iOS];
}

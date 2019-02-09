<p align="center">
<img src="https://github.com/jhomlala/catcher/blob/master/screenshots/logo.png">
</p>

# Catcher

[![pub package](https://img.shields.io/pub/v/catcher.svg)](https://pub.dartlang.org/packages/catcher)
[![pub package](https://img.shields.io/github/license/jhomlala/catcher.svg?style=flat)](https://github.com/jhomlala/catcher)
[![pub package](https://img.shields.io/badge/platform-flutter-blue.svg)](https://github.com/jhomlala/catcher)

Catcher is Flutter plugin which automatically catches error/exceptions and handle them. Catcher offers mutliple way to handle errors.
Catcher is heavily inspired from ACRA: https://github.com/ACRA/acra
Catcher is solution for developers which want to get errors informations without using Crashlytics or Sentry product. It's also great if you have
your own backend where you're storing application logs, so you can manipulate it anyway you want.  


## Install

Add this line to your **pubspec.yaml**:
```yaml
dependencies:
  catcher: ^0.0.8
```

Then run this command:
```bash
$ flutter packages get
```

Then add this import:
```dart
import 'import 'package:catcher/catcher_plugin.dart';
```

## Table of contents
[Basic example](#basic-example)  
[Catcher usage](#catcher-usage)  
[Adding navigator key](#adding-navigator-key)  
[Catcher configuration](#catcher-configuration)  
[Report catched exception](#report-catched-exception)  
[Report modes](#report-modes)  
* [Silent Report Mode](#silent-report-mode)
* [Notification Report Mode](#notification-report-mode)  
* [Dialog Report Mode](#dialog-report-mode)  
* [Page Report Mode](#page-report-mode)  
[Handlers](#handlers)  
* [Console Handler](#console-handler)  
* [Email Manual Handler](#email-manual-handler)  
* [Email Auto Handler](#email-auto-handler)  
* [Http Handler](#http-handler)  
* [File Handler](#file-handler)  
* [Toast Handler](#toast-handler)  


## Basic example

Basic example utilizes debug config with Dialog Report Mode and Console Handler and release config with Dialog Report Mode and Email Manual Handler.

```dart
import 'package:flutter/material.dart';
import 'package:catcher/catcher_plugin.dart';

main() {
  CatcherOptions debugOptions =
      CatcherOptions(DialogReportMode(), [ConsoleHandler()]);
  CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
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
                child: Text("Generate error"),
                onPressed: () => generateError()));
  }

  generateError() async {
    throw "Test exception";
  }
}

```
Here in this code, Catcher will be initiated with 3 parameters: root widget which is MyApp, debug configuration and release configuration. 
Debug configuration has dialog report mode and console handler, release configuration has dialog report mode and manual email handler.
If you run this code you will see screen with "Generate error" button on middle of the screen. 
After clicking on it, it will generate test exception, which will be handled by Catcher. Before Catcher process exception to handler, it will
show dialog with information for user. This dialog is shown because we have used DialogReportHandler. Once user confirms action in this dialog,
report will be send to console handler which will log to console error informations.

<p align="center">
<img src="https://github.com/jhomlala/catcher/blob/master/screenshots/6.png" width="250px"> <br/> 
  <i>Dialog with default confirmation message</i>
</p>


  
```dart
I/flutter ( 7457): [2019-02-09 12:40:21.527271 | ConsoleHandler | INFO] ============================== CATCHER LOG ==============================
I/flutter ( 7457): [2019-02-09 12:40:21.527742 | ConsoleHandler | INFO] Crash occured on 2019-02-09 12:40:20.424286
I/flutter ( 7457): [2019-02-09 12:40:21.527827 | ConsoleHandler | INFO] 
I/flutter ( 7457): [2019-02-09 12:40:21.527908 | ConsoleHandler | INFO] ------- DEVICE INFO -------
I/flutter ( 7457): [2019-02-09 12:40:21.528233 | ConsoleHandler | INFO] id: PSR1.180720.061
I/flutter ( 7457): [2019-02-09 12:40:21.528337 | ConsoleHandler | INFO] androidId: 726e4abc58dde277
I/flutter ( 7457): [2019-02-09 12:40:21.528431 | ConsoleHandler | INFO] board: goldfish_x86
I/flutter ( 7457): [2019-02-09 12:40:21.528512 | ConsoleHandler | INFO] bootloader: unknown
I/flutter ( 7457): [2019-02-09 12:40:21.528595 | ConsoleHandler | INFO] brand: google
I/flutter ( 7457): [2019-02-09 12:40:21.528694 | ConsoleHandler | INFO] device: generic_x86
I/flutter ( 7457): [2019-02-09 12:40:21.528774 | ConsoleHandler | INFO] display: sdk_gphone_x86-userdebug 9 PSR1.180720.061 5075414 dev-keys
I/flutter ( 7457): [2019-02-09 12:40:21.528855 | ConsoleHandler | INFO] fingerprint: google/sdk_gphone_x86/generic_x86:9/PSR1.180720.061/5075414:userdebug/dev-keys
I/flutter ( 7457): [2019-02-09 12:40:21.528939 | ConsoleHandler | INFO] hardware: ranchu
I/flutter ( 7457): [2019-02-09 12:40:21.529023 | ConsoleHandler | INFO] host: vped9.mtv.corp.google.com
I/flutter ( 7457): [2019-02-09 12:40:21.529813 | ConsoleHandler | INFO] isPsychicalDevice: false
I/flutter ( 7457): [2019-02-09 12:40:21.530178 | ConsoleHandler | INFO] manufacturer: Google
I/flutter ( 7457): [2019-02-09 12:40:21.530345 | ConsoleHandler | INFO] model: Android SDK built for x86
I/flutter ( 7457): [2019-02-09 12:40:21.530443 | ConsoleHandler | INFO] product: sdk_gphone_x86
I/flutter ( 7457): [2019-02-09 12:40:21.530610 | ConsoleHandler | INFO] tags: dev-keys
I/flutter ( 7457): [2019-02-09 12:40:21.530713 | ConsoleHandler | INFO] type: userdebug
I/flutter ( 7457): [2019-02-09 12:40:21.530825 | ConsoleHandler | INFO] versionBaseOs: 
I/flutter ( 7457): [2019-02-09 12:40:21.530922 | ConsoleHandler | INFO] versionCodename: REL
I/flutter ( 7457): [2019-02-09 12:40:21.531074 | ConsoleHandler | INFO] versionIncremental: 5075414
I/flutter ( 7457): [2019-02-09 12:40:21.531573 | ConsoleHandler | INFO] versionPreviewSdk: 0
I/flutter ( 7457): [2019-02-09 12:40:21.531659 | ConsoleHandler | INFO] versionRelase: 9
I/flutter ( 7457): [2019-02-09 12:40:21.531740 | ConsoleHandler | INFO] versionSdk: 28
I/flutter ( 7457): [2019-02-09 12:40:21.531870 | ConsoleHandler | INFO] versionSecurityPatch: 2018-08-05
I/flutter ( 7457): [2019-02-09 12:40:21.532002 | ConsoleHandler | INFO] 
I/flutter ( 7457): [2019-02-09 12:40:21.532078 | ConsoleHandler | INFO] ------- APP INFO -------
I/flutter ( 7457): [2019-02-09 12:40:21.532167 | ConsoleHandler | INFO] version: 1.0
I/flutter ( 7457): [2019-02-09 12:40:21.532250 | ConsoleHandler | INFO] appName: catcher_example
I/flutter ( 7457): [2019-02-09 12:40:21.532345 | ConsoleHandler | INFO] buildNumber: 1
I/flutter ( 7457): [2019-02-09 12:40:21.532426 | ConsoleHandler | INFO] packageName: com.jhomlala.catcherexample
I/flutter ( 7457): [2019-02-09 12:40:21.532667 | ConsoleHandler | INFO] 
I/flutter ( 7457): [2019-02-09 12:40:21.532944 | ConsoleHandler | INFO] ---------- ERROR ----------
I/flutter ( 7457): [2019-02-09 12:40:21.533096 | ConsoleHandler | INFO] Test exception
I/flutter ( 7457): [2019-02-09 12:40:21.533179 | ConsoleHandler | INFO] 
I/flutter ( 7457): [2019-02-09 12:40:21.533257 | ConsoleHandler | INFO] ------- STACK TRACE -------
I/flutter ( 7457): [2019-02-09 12:40:21.533695 | ConsoleHandler | INFO] #0      ChildWidget.generateError (package:catcher_example/file_example.dart:62:5)
I/flutter ( 7457): [2019-02-09 12:40:21.533799 | ConsoleHandler | INFO] <asynchronous suspension>
I/flutter ( 7457): [2019-02-09 12:40:21.533879 | ConsoleHandler | INFO] #1      ChildWidget.build.<anonymous closure> (package:catcher_example/file_example.dart:53:61)
I/flutter ( 7457): [2019-02-09 12:40:21.534149 | ConsoleHandler | INFO] #2      _InkResponseState._handleTap (package:flutter/src/material/ink_well.dart:507:14)
I/flutter ( 7457): [2019-02-09 12:40:21.534230 | ConsoleHandler | INFO] #3      _InkResponseState.build.<anonymous closure> (package:flutter/src/material/ink_well.dart:562:30)
I/flutter ( 7457): [2019-02-09 12:40:21.534321 | ConsoleHandler | INFO] #4      GestureRecognizer.invokeCallback (package:flutter/src/gestures/recognizer.dart:102:24)
I/flutter ( 7457): [2019-02-09 12:40:21.534419 | ConsoleHandler | INFO] #5      TapGestureRecognizer._checkUp (package:flutter/src/gestures/tap.dart:242:9)
I/flutter ( 7457): [2019-02-09 12:40:21.534524 | ConsoleHandler | INFO] #6      TapGestureRecognizer.handlePrimaryPointer (package:flutter/src/gestures/tap.dart:175:7)
I/flutter ( 7457): [2019-02-09 12:40:21.534608 | ConsoleHandler | INFO] #7      PrimaryPointerGestureRecognizer.handleEvent (package:flutter/src/gestures/recognizer.dart:315:9)
I/flutter ( 7457): [2019-02-09 12:40:21.534686 | ConsoleHandler | INFO] #8      PointerRouter._dispatch (package:flutter/src/gestures/pointer_router.dart:73:12)
I/flutter ( 7457): [2019-02-09 12:40:21.534765 | ConsoleHandler | INFO] #9      PointerRouter.route (package:flutter/src/gestures/pointer_router.dart:101:11)
I/flutter ( 7457): [2019-02-09 12:40:21.534843 | ConsoleHandler | INFO] #10     _WidgetsFlutterBinding&BindingBase&GestureBinding.handleEvent (package:flutter/src/gestures/binding.dart:180:19)
I/flutter ( 7457): [2019-02-09 12:40:21.534973 | ConsoleHandler | INFO] #11     _WidgetsFlutterBinding&BindingBase&GestureBinding.dispatchEvent (package:flutter/src/gestures/binding.dart:158:22)
I/flutter ( 7457): [2019-02-09 12:40:21.535052 | ConsoleHandler | INFO] #12     _WidgetsFlutterBinding&BindingBase&GestureBinding._handlePointerEvent (package:flutter/src/gestures/binding.dart:138:7)
I/flutter ( 7457): [2019-02-09 12:40:21.535136 | ConsoleHandler | INFO] #13     _WidgetsFlutterBinding&BindingBase&GestureBinding._flushPointerEventQueue (package:flutter/src/gestures/binding.dart:101:7)
I/flutter ( 7457): [2019-02-09 12:40:21.535216 | ConsoleHandler | INFO] #14     _WidgetsFlutterBinding&BindingBase&GestureBinding._handlePointerDataPacket (package:flutter/src/gestures/binding.dart:85:7)
I/flutter ( 7457): [2019-02-09 12:40:21.535600 | ConsoleHandler | INFO] #15     _rootRunUnary (dart:async/zone.dart:1136:13)
I/flutter ( 7457): [2019-02-09 12:40:21.535753 | ConsoleHandler | INFO] #16     _CustomZone.runUnary (dart:async/zone.dart:1029:19)
I/flutter ( 7457): [2019-02-09 12:40:21.536008 | ConsoleHandler | INFO] #17     _CustomZone.runUnaryGuarded (dart:async/zone.dart:931:7)
I/flutter ( 7457): [2019-02-09 12:40:21.536138 | ConsoleHandler | INFO] #18     _invoke1 (dart:ui/hooks.dart:170:10)
I/flutter ( 7457): [2019-02-09 12:40:21.536271 | ConsoleHandler | INFO] #19     _dispatchPointerDataPacket (dart:ui/hooks.dart:122:5)
I/flutter ( 7457): [2019-02-09 12:40:21.536375 | ConsoleHandler | INFO] 
I/flutter ( 7457): [2019-02-09 12:40:21.536539 | ConsoleHandler | INFO] ======================================================================
```

## Catcher usage

### Adding navigator key
In order to make work Page Report Mode and Dialog Report Mode, you must include navigator key. Catcher plugin exposes key which must be included in your MaterialApp or WidgetApp:

```dart
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //********************************************
      navigatorKey: Catcher.navigatorKey,
      //********************************************
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: ChildWidget()),
    );
  }

```
You need to provide this key, because Catcher needs context of navigator to show dialogs/pages. There is no need to include this navigator key if you won't use Page/Dialog Report Mode.


### Catcher configuration
Catcher instance needs 1 required and 3 optional parameters.

* rootWidget (required) - instance of your root application widget
* debugConfig (optional) - config used when Catcher detects that application runs in debug mode
* releaseConfig (optional) - config used when Catcher detects that application runs in release mode
* profileConfig (optional) - config used when Catcher detects that application runs in profile mode


```dart
main() {
  CatcherOptions debugOptions =
  CatcherOptions(DialogReportMode(), [ConsoleHandler()]);
  CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
    EmailManualHandler(["recipient@email.com"])
  ]);
  CatcherOptions profileOptions = CatcherOptions(
    NotificationReportMode(), [ConsoleHandler(), ToastHandler()],
    handlerTimeout: 10000, customParameters: {"example": "example_parameter"},);
  Catcher(MyApp(), debugConfig: debugOptions, releaseConfig: releaseOptions, profileConfig: profileOptions);
}
```
CatcherOptions parameters:
reportMode - describes how error report will be shown to user, see report modes to get more informations
handlers - list of handlers, which will process report, see handlers to get more informations
handlerTimeout - timeout in milliseconds, this parameter describes max time of handling report by handler
customParameters - map of additional parameters that will be included in report (for example user id or user name)


### Report catched exception
Catcher won't process exceptions catched in try/catch block. You can send exception from try catch block to Catcher:

```dart
try {
  ...
} catch (error,stackTrace) {
  Catcher.getInstance().reportCheckedError(error, stackTrace)
}
```

### Report modes
Report mode is the process of gathering user permission to handle error. User can accept or deny permission to handle error. There are 4 types of report mode:


#### Silent Report Mode
Silent Report Mode is default report mode. This report mode doesn't ask user for permission to handle crash logs. It will push logs automatically to handlers.

```dart
ReportMode reportMode = SilentReportMode();
```

#### Notification Report Mode
Notification Report Mode shows local notification about error. Once user clicks on notification, report will be pushed to handlers.

```dart
ReportMode reportMode = NotificationReportMode();
```

<p align="center">
<img width="250px" src="https://github.com/jhomlala/catcher/blob/master/screenshots/1.png"><br/>
  <i>Notification Report Mode</i>
</p>

#### Dialog Report Mode
Dialog Report Mode shows dialog with information about error. Dialog has title, description and 2 buttons: Accept and Cancel. Once user clicks on Accept button, report will be pushed to handlers.

```dart
  ReportMode reportMode = DialogReportMode(
      titleText: "Crash",
      descriptionText: "My description",
      acceptText: "OK",
      cancelText: "Back");
```
Dialog Report Mode can be configured with optional parameters:
titleText (optional) - text for dialog title
descriptionText (optional) - text for dialog description
acceptText (optional) - confirmation button text
cancelText (optional) - cancel button text


<p align="center">
<img width="250px" src="https://github.com/jhomlala/catcher/blob/master/screenshots/6.png"><br/>
  <i>Dialog report mode</i>
</p>

#### Page Report Mode
Page Report Mode shows new page with information about error. Page has title, description, stack trace view and 2 buttons: Accept and Cancel. Once user clicks on Accept button, report will be pushed to handlers.

```dart
  ReportMode reportMode = PageReportMode(
      titleText: "Crash",
      descriptionText: "My description",
      acceptText: "OK",
      cancelText: "Back",
      showStackTrace: false);
```

Page Report Mode can be configured with optional parameters:
titleText (optional) - text for title in toobar
descriptionText (optional) - text for page descrption
acceptText (optional) - confirmation button text
cancelText (optional) - cancel button text
showStackTrace (optional) - enables/disables stack trace view

<p align="center">
<img width="250px" src="https://github.com/jhomlala/catcher/blob/master/screenshots/7.png"><br/>
  <i>Page report mode</i>
</p>

### Handlers
Handlers are an last point in error processing flow. They are doing specific task with error report, for example logging report to console.

#### Console Handler


Console Handler is the default and basic handler. It show crash log in console. Console logger allows you to parametrize log output:

```dart
ConsoleHandler(
          enableApplicationParameters: true,
          enableDeviceParameters: true,
          enableCustomParameters: true,
          enableStackTrace: true)

```

* enableApplicationParameters (optional) - display in log section with application data:

```dart
I/flutter ( 4820): ------- APP INFO -------
I/flutter ( 4820): version: 1.0
I/flutter ( 4820): appName: catcher_example
I/flutter ( 4820): buildNumber: 1
I/flutter ( 4820): packageName: com.jhomlala.catcherexample
I/flutter ( 4820): 
```

* enableDeviceParameters (optional) - display in log section with device data (it will show android/ios data):

```dart
I/flutter ( 4820): ------- DEVICE INFO -------
I/flutter ( 4820): id: PSR1.180720.061
I/flutter ( 4820): androidId: fd97a76448e87410
I/flutter ( 4820): board: goldfish_x86
I/flutter ( 4820): bootloader: unknown
I/flutter ( 4820): brand: google
I/flutter ( 4820): device: generic_x86
I/flutter ( 4820): display: sdk_gphone_x86-userdebug 9 PSR1.180720.061 5075414 dev-keys
I/flutter ( 4820): fingerprint: google/sdk_gphone_x86/generic_x86:9/PSR1.180720.061/5075414:userdebug/dev-keys
I/flutter ( 4820): hardware: ranchu
I/flutter ( 4820): host: vped9.mtv.corp.google.com
I/flutter ( 4820): isPsychicalDevice: false
I/flutter ( 4820): manufacturer: Google
I/flutter ( 4820): model: Android SDK built for x86
I/flutter ( 4820): product: sdk_gphone_x86
I/flutter ( 4820): tags: dev-keys
I/flutter ( 4820): type: userdebug
I/flutter ( 4820): versionBaseOs: 
I/flutter ( 4820): versionCodename: REL
I/flutter ( 4820): versionIncremental: 5075414
I/flutter ( 4820): versionPreviewSdk: 0
I/flutter ( 4820): versionRelase: 9
I/flutter ( 4820): versionSdk: 28
I/flutter ( 4820): versionSecurityPatch: 2018-08-05
```

* enableCustomParameters (optional) - display in log section with custom parameters passed to Catcher constructor

* enableStackTrace (optional) - display in log section with stack trace:

```dart
I/flutter ( 5073): ------- STACK TRACE -------
I/flutter ( 5073): #0      _MyAppState.generateError (package:catcher_example/main.dart:38:5)
I/flutter ( 5073): <asynchronous suspension>
I/flutter ( 5073): #1      _MyAppState.build.<anonymous closure> (package:catcher_example/main.dart:31:69)
I/flutter ( 5073): #2      _InkResponseState._handleTap (package:flutter/src/material/ink_well.dart:507:14)
I/flutter ( 5073): #3      _InkResponseState.build.<anonymous closure> (package:flutter/src/material/ink_well.dart:562:30)
I/flutter ( 5073): #4      GestureRecognizer.invokeCallback (package:flutter/src/gestures/recognizer.dart:102:24)
I/flutter ( 5073): #5      TapGestureRecognizer._checkUp (package:flutter/src/gestures/tap.dart:242:9)
I/flutter ( 5073): #6      TapGestureRecognizer.handlePrimaryPointer (package:flutter/src/gestures/tap.dart:175:7)
I/flutter ( 5073): #7      PrimaryPointerGestureRecognizer.handleEvent (package:flutter/src/gestures/recognizer.dart:315:9)
I/flutter ( 5073): #8      PointerRouter._dispatch (package:flutter/src/gestures/pointer_router.dart:73:12)
I/flutter ( 5073): #9      PointerRouter.route (package:flutter/src/gestures/pointer_router.dart:101:11)
I/flutter ( 5073): #10     _WidgetsFlutterBinding&BindingBase&GestureBinding.handleEvent (package:flutter
```
#### Email Manual Handler
Email manual handler can be used to send email manually by user. It opens default email application with prepared email.

```dart
EmailManualHandler(
      ["email1@email.com", "email2@email.com"],
      enableDeviceParameters: true,
      enableStackTrace: true,
      enableCustomParameters: true,
      enableApplicationParameters: true,
      sendHtml: true,
      emailTitle: "Sample Title",
      emailHeader: "Sample Header",
      printLogs: true
```

Email Manual Handler parameters:
* recipients (required) - list of email addresses of recipients
* enableDeviceParameters (optional) - see Console Handler description
* enableStackTrace (optional) - see Console Handler description
* enableCustomParameters (optional) - see Console Handler description
* enableApplicationParameters (optional) - see Console Handler description
* sendHtml (optional) - enable/disable html email formatting
* emailTitle (optional) - set custom email title
* emailHeader (optional) - set additional email text header
* printLogs (optional) - enable/disable debug logs

#### Email Auto Handler
Email handler can be used to send automatically email with error reports. Email handler has multiple configuration parameters. Few of them are required, other are optional. These parameters are required:

```dart
 EmailHandler("smtp.gmail.com", 587, "somefakeemail@gmail.com", "Catcher",
          "FakePassword", ["myemail@gmail.com"])
```
We need to setup email smtp server, email account and recipient. Currently, only Gmail was tested and worked. You can try use other email providers, but there can be errors.  

List of all parameters: 
 
* smtpHost (required) - host address of your email, for example host for gmail is smtp.gmail.com  
* smtpPort (required) - smtp port of your email, for example port for gmail is 587  
* senderEmail (required) - email from which Catcher will send email (it will be sender of error emails)  
* senderName (required) - name of sender email
* senderPassword (required) - password for sender email 
* recipients (required) - list which contains recipient emails   
* enableSSL (optional) - if your email provider supports SSL, you can enable this option
* enableDeviceParameters (optional) - please look in console handler description
* enableApplicationParameters (optional) - please look in console handler description
* enableStackTrace (optional) - please look in console handler description
* enableCustomParameters (optional) - please look in console handler description
* emailTitle (optional) - custom title of report email, if not set then title will be: `Handled Error: >> [Error name] <<`
* emailHeader (optional)-  custom header message before report data
* sendHtml (optional) - enable/disable html data in your email, if enabled then html will be sent and your report will look much better
* printLog (optional) - enable/disable debug logs

Example email:
<p align="center">
<img src="https://github.com/jhomlala/catcher/blob/master/screenshots/3.png">
</p>

#### Http Handler

Http Handler provides feature for sending report to external server. Data will be encoded in JSON and sent to specified server. Currently only POST request can be send. Minimal example:

```dart
HttpHandler(HttpRequestType.post, Uri.parse("http://logs.server.com")
```

All parameters list:
* requestType (required) - type of request, currently only POST is supported  
* endpointUri (required) - uri address of server  
* headers (optional) - map of additional headers that can be send in http request  
* requestTimeout (optional) - request time in milliseconds  
* printLogs (optional) - show debug logs  

You can try using example backend server which handles logs. It's written in Java 8 and Spring Framework and uses material design.
You can find code of backend server here: https://github.com/jhomlala/catcher/tree/master/backend

<p align="center">
<img src="https://github.com/jhomlala/catcher/blob/master/screenshots/4.png">
</p>

Note: Remeber to add Internet permission in Android Manifest:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

#### File Handler
File handler allows to store logs in file. Minimal example:

```dart
Future<File> getFile() async {
  final directory = await getApplicationDocumentsDirectory();
  return File(directory.path+"/logs.txt");
}

void main() async{

  File file = await getFile();

  Catcher(
      application: MyApp(),
      handlers: [
        ConsoleHandler(),
        FileHandler(file),
      ],
      reportModeType: ReportModeType.silent);
}
```

All parameters list:  
* file (required) - the file where you want to store your logs  
* enableDeviceParameters (optional) - please look in console handler description   
* enableApplicationParameters (optional) - please look in console handler description  
* enableStackTrace (optional) - please look in console handler description  
* enableCustomParameters (optional) - please look in console handler description  
* printLogs (optional) - enable/disable debug logs  

#### Toast Handler
Toast handler allows to show short message in toast. Minimal example:

All parameters list:
* gravity (optional) - location of the toast on screen top/middle/bottom
* length (optional) - length of toast: long or short
* backgroundColor (optional) - background color of toast
* textColor (optional) - text color of toast
* fontSize (optional) - text size
* customMessage (optional) - custom message for toast, if not set then "Error occured: error" will be displayed.

<p align="center">
<img src="https://github.com/jhomlala/catcher/blob/master/screenshots/5.png" width="250px">
</p>

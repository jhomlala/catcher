<p align="center">
<img src="https://github.com/jhomlala/catcher/blob/master/screenshots/logo.png">
</p>

# Catcher

[![pub package](https://img.shields.io/pub/v/catcher.svg)](https://pub.dartlang.org/packages/catcher)


Catcher is Flutter plugin which catches automatically errors/exceptions and report them. Catcher offers multiple way to report catched error. There are handlers:

* Console Handler
* Email Handler
* File Handler
* Http Handler
* Toast Handler

Reports can be generated in two modes:

* Silent Report Mode
* Notificaiton Report Mode

## Install

Add this line to your **pubspec.yaml**:
```yaml
dependencies:
  catcher: ^0.0.7
```

Then run this command:
```bash
$ flutter packages get
```

Then add this import:
```dart
import 'package:catcher/catcher.dart';
```

## Basic example

Basic example has Simple Report Mode and Console Handler:

```dart
void main() => Catcher(MyApp(), handlers: [ConsoleHandler()]);

class MyApp extends StatefulWidget{

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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(child:
          FlatButton(child: Text("Generate error"),onPressed: () => generateError())
        ),
      ),
    );
  }

  generateError()  async {
    throw "Test exception";
  }
}
```

If you run this code you will see screen with "Generate error" button on middle of the screen. After clicking on it, you will generate error, which will be handler by Catcher. You will see these logs in your console:


```dart
I/flutter ( 4820): ============================== CATCHER LOG ==============================
I/flutter ( 4820): Crash occured on 2019-02-02 08:18:14.707484
I/flutter ( 4820): 
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
I/flutter ( 4820): 
I/flutter ( 4820): ------- APP INFO -------
I/flutter ( 4820): version: 1.0
I/flutter ( 4820): appName: catcher_example
I/flutter ( 4820): buildNumber: 1
I/flutter ( 4820): packageName: com.jhomlala.catcherexample
I/flutter ( 4820): 
I/flutter ( 4820): ---------- ERROR ----------
I/flutter ( 4820): Test exception
I/flutter ( 4820): 
I/flutter ( 4820): ------- STACK TRACE -------
I/flutter ( 4820): #0      _MyAppState.generateError (package:catcher_example/main.dart:37:5)
I/flutter ( 4820): <asynchronous suspension>
I/flutter ( 4820): #1      _MyAppState.build.<anonymous closure> (package:catcher_example/main.dart:30:69)
I/flutter ( 4820): #2      _InkResponseState._handleTap (package:flutter/src/material/ink_well.dart:507:14)
I/flutter ( 4820): #3      _InkResponseState.build.<anonymous closure> (package:flutter/src/material/ink_well.dart:562:30)
I/flutter ( 4820): #4      GestureRecognizer.invokeCallback (package:flutter/src/gestures/recognizer.dart:102:24)
I/flutter ( 4820): #5      TapGestureRecognizer._checkUp (package:flutter/src/gestures/tap.dart:242:9)
I/flutter ( 4820): #6      TapGestureRecognizer.handlePrimaryPointer (package:flutter/src/gestures/tap.dart:175:7)
I/flutter ( 4820): #7      PrimaryPointerGestureRecognizer.handleEvent (package:flutter/src/gestures/recognizer.dart:315:9)
I/flutter ( 4820): #8      PointerRouter._dispatch (package:flutter/src/gestures/pointer_router.dart:73:12)
I/flutter ( 4820): #9      PointerRouter.route (package:flutter/src/gestures/pointer_router.dart:101:11)
I/flutter ( 4820): #10     _WidgetsFlutterBinding&BindingBase&GestureBinding.handleEvent (package:flutter
I/flutter ( 4820): ======================================================================
```

## Advanced usage

### Catcher configuration
```dart
Catcher(MyApp(),
        handlerTimeout: 5000,
        handlers: [ConsoleHandler(), ToastHandler()],
        customParameters: {"application_version": "debug"},
        reportModeType: ReportModeType.silent);
```

* application - base application widget
* handlers - list of all handlers
* handlerTimeout - max time of handler to process report error
* reportModeType - type of report mode: silent or notification
* customParameters - list of custom parameters that will be send with report


### Report catched exception
When you catch your exception in try/catch block, then exception will not be processed by Catcher. You can send error manually to catcher by using:

```dart
Catcher.getInstance().reportCheckedError(error, stackTrace)
```

### Report modes

There are two report modes:

* Silent Report Mode which is default one. This report mode doesn't ask user for permission to handle crash logs. It will push logs automatically to handlers.

* Notification Report Mode is another report mode. It shows notificaiton in user device after crash. User need to click on notification to send logs to handlers.

To configure report mode, you need to specify `reportModeType` parameter in Catcher constructor:

```dart
Catcher(MyApp(), handlers: [ConsoleHandler()], reportModeType: ReportModeType.notification );
```

For silent mode there won't be any visuals shown for user. For notification mode, this notification will be shown:
<p align="justify">
<img width="250px" src="https://github.com/jhomlala/catcher/blob/master/screenshots/1.png">
</p>

### Console Handler
Console Handler is the default and basic handler. It show crash log in console. Console logger allows you to parametrize log output:

```dart
ConsoleHandler(
          enableApplicationParameters: true,
          enableDeviceParameters: true,
          enableCustomParameters: true,
          enableStackTrace: true)

```

* enableApplicationParameters: display in log section with application data:

```dart
I/flutter ( 4820): ------- APP INFO -------
I/flutter ( 4820): version: 1.0
I/flutter ( 4820): appName: catcher_example
I/flutter ( 4820): buildNumber: 1
I/flutter ( 4820): packageName: com.jhomlala.catcherexample
I/flutter ( 4820): 
```

* enableDeviceParameters: display in log section with device data (it will show android/ios data):

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

* enableCustomParameters: display in log section with custom parameters passed to Catcher constructor

* enableStackTrace: display in log section with stack trace:

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

### Email Handler
Email handler can be used to send automatically email with error reports. Email handler has multiple configuration parameters. Few of them are required, other are optional. These parameters are required:

```dart
 EmailHandler("smtp.gmail.com", 587, "somefakeemail@gmail.com", "Catcher",
          "FakePassword", ["myemail@gmail.com"])
```
We need to setup email smtp server, email account and recipient. Currently, only Gmail was tested and worked. You can try use other email providers, but there can be errors.  

List of all parameters: 

Required:  
* smtpHost - host address of your email, for example host for gmail is smtp.gmail.com  
* smtpPort - smtp port of your email, for example port for gmail is 587  
* senderEmail - email from which Catcher will send email (it will be sender of error emails)  
* senderName - name of sender email
* senderPassword - password for sender email 
* recipients - list which contains recipient emails  

Optional: 
* enableSSL - if your email provider supports SSL, you can enable this option
* enableDeviceParameters - please look in console handler description
* enableApplicationParameters - please look in console handler description
* enableStackTrace - please look in console handler description
* enableCustomParameters - please look in console handler description
* emailTitle - custom title of report email, if not set then title will be: `Handled Error: >> [Error name] <<`
* emailHeader - custom header message before report data
* sendHtml - enable/disable html data in your email, if enabled then html will be sent and your report will look much better
* printLog - enable/disable debug logs

Example email:
<p align="center">
<img src="https://github.com/jhomlala/catcher/blob/master/screenshots/3.png">
</p>

### Http Handler

Http Handler provides feature for sending report to external server. Data will be encoded in JSON and sent to specified server. Currently only POST request can be send. Minimal example:

```dart
HttpHandler(HttpRequestType.post, Uri.parse("http://logs.server.com")
```

All parameters list:
* requestType - type of request, currently only POST is supported  
* endpointUri - uri address of server  
* headers - map of additional headers that can be send in http request  
* requestTimeout - request time in milliseconds  
* printLogs - show debug logs  

You can try using example backend server which handles logs. It's written in Java 8 and Spring Framework and uses material design.
You can find code of backend server here: https://github.com/jhomlala/catcher/tree/master/backend

<p align="center">
<img src="https://github.com/jhomlala/catcher/blob/master/screenshots/4.png">
</p>

Note: Remeber to add Internet permission in Android Manifest:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

### File Handler
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
* file - the file where you want to store your logs  
* enableDeviceParameters - please look in console handler description   
* enableApplicationParameters - please look in console handler description  
* enableStackTrace - please look in console handler description  
* enableCustomParameters - please look in console handler description  
* printLogs - enable/disable debug logs  

### Toast Handler
Toast handler allows to show short message in toast. Minimal example:

All parameters list:
* gravity - location of the toast on screen top/middle/bottom
* length - length of toast: long or short
* backgroundColor - background color of toast
* textColor - text color of toast
* fontSize - text size
* customMessage - custom message for toast, if not set then "Error occured: error" will be displayed.

<p align="center">
<img src="https://github.com/jhomlala/catcher/blob/master/screenshots/5.png" width="250px">
</p>

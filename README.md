# Catcher

[![pub package](https://img.shields.io/pub/v/catcher.svg)](https://pub.dartlang.org/packages/catcher)


Catcher is Flutter library which catches automatically errors/exceptions and report them. Catcher offers multiple way to report catched error. There are handlers:

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
  catcher: ^0.0.3
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
void main() => Catcher(application: MyApp(), handlers: [ConsoleHandler()]);

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


```
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

### Report modes

There are two report modes:

* Silent Report Mode which is default one. This report mode doesn't ask user for permission to handle crash logs. It will push logs automatically to handlers.

* Notification Report Mode is another report mode. It shows notificaiton in user device after crash. User need to click on notification to send logs to handlers.

To configure report mode, you need to specify `reportModeType` parameter in Catcher constructor:

```dart
Catcher(application: MyApp(), handlers: [ConsoleHandler()], reportModeType: ReportModeType.notification );
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

```
I/flutter ( 4820): ------- APP INFO -------
I/flutter ( 4820): version: 1.0
I/flutter ( 4820): appName: catcher_example
I/flutter ( 4820): buildNumber: 1
I/flutter ( 4820): packageName: com.jhomlala.catcherexample
I/flutter ( 4820): 
```

* enableDeviceParameters: display in log section with device data (it will show android/ios data):

```
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



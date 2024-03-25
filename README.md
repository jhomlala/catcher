<p align="center">
<img src="https://raw.githubusercontent.com/ThexXTURBOXx/catcher_2/master/screenshots/logo.png">
</p>

# Catcher 2

**This project is a continuation of [catcher](https://github.com/jhomlala/catcher) by Jakub Homlala with many new features and bug fixes.**

[![pub package](https://img.shields.io/pub/v/catcher_2.svg)](https://pub.dartlang.org/packages/catcher_2)
[![CI](https://github.com/ThexXTURBOXx/catcher_2/actions/workflows/ci.yml/badge.svg)](https://github.com/ThexXTURBOXx/catcher_2/actions/workflows/ci.yml)
[![license](https://img.shields.io/github/license/ThexXTURBOXx/catcher_2.svg?style=flat)](https://github.com/ThexXTURBOXx/catcher_2)
[![flutter](https://img.shields.io/badge/platform-flutter-blue.svg)](https://github.com/ThexXTURBOXx/catcher_2)
[![awesome flutter](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)](https://github.com/Solido/awesome-flutter)


Catcher 2 is a Flutter plugin which automatically catches errors/exceptions and offers multiple ways to handle them.<br/>
It is heavily inspired from ACRA: https://github.com/ACRA/acra.<br/>
It supports Android, iOS, Web, Linux, Windows and MacOS platforms.


## Install

Add this line to your **pubspec.yaml**:
```yaml
dependencies:
  catcher_2: ^1.0.0
```

Then run this command:
```bash
$ flutter packages get
```

Then add this import:
```dart
import 'package:catcher_2/catcher_2.dart';
```

And now you can use all the features as demonstrated below!

## Upgrading from `catcher`

If you used `catcher` correctly (and without extra hackage) before, it should be sufficient to replace the following strings *everywhere*:
- `Catcher` -> `Catcher2`
- `catcher` -> `catcher_2` (only in very few places you need to use `catcher2` instead)

Also note the following:
- `HttpHandler` had some breaking changes due to the upgrade to `dio` 5.x

If you are still unsure or something is not working as well as before, please [open a new issue](https://github.com/ThexXTURBOXx/catcher_2/issues/new/choose).

## Table of contents
[Platform support](#platform-support)   
[Basic example](#basic-example)  
[Catcher 2 usage](#catcher-2-usage)
[Adding navigator key](#adding-navigator-key)  
[Catcher 2 configuration](#catcher-2-configuration)    
[Report caught exception](#report-caught-exception)   
[Localization](#localization)    
  
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
* [Sentry Handler](#sentry-handler)
* [Slack Handler](#slack-handler)
* [Discord Handler](#discord-handler)
* [Snackbar Handler](#snackbar-handler)
* [Crashlytics Handler](#crashlytics-handler)

[Test Exception](#test-exception)  
[Explicit exception report handler map](#explicit-exception-report-handler-map)  
[Explicit exception report mode map](#explicit-exception-report-mode-map)  
[Error widget](#error-widget)  
[Current config](#current-config)  
[Update config](#update-config)  
[Screenshots](#screenshots) 

## Platform support
To check which features of Catcher 2 are available in given platform visit this page: [Platform support](https://github.com/ThexXTURBOXx/catcher_2/blob/master/platform_support.md)

## Basic example
Basic example utilizes debug config with Dialog Report Mode and Console Handler and release config with Dialog Report Mode and Email Manual Handler.

To start using Catcher 2, you have to:   
1. Create Catcher 2 configuration (you can use only debug config at start)   
2. Create Catcher 2 instance and pass your root widget along with its configuration   
3. Add navigator key to MaterialApp or CupertinoApp   
   
Here is complete example:   

```dart
import 'package:flutter/material.dart';
import 'package:catcher_2/catcher_2.dart';

main() {
  /// STEP 1. Create Catcher 2 configuration. 
  /// Debug configuration with dialog report mode and console handler. It will show dialog and once user accepts it, error will be shown   /// in console.
  Catcher2Options debugOptions =
      Catcher2Options(DialogReportMode(), [ConsoleHandler()]);
      
  /// Release configuration. Same as above, but once user accepts dialog, user will be prompted to send email with crash to support.
  Catcher2Options releaseOptions = Catcher2Options(DialogReportMode(), [
    EmailManualHandler(["support@email.com"])
  ]);

  /// STEP 2. Pass your root widget (MyApp) along with Catcher 2 configuration:
  Catcher2(rootWidget: MyApp(), debugConfig: debugOptions, releaseConfig: releaseOptions);
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
      /// STEP 3. Add navigator key from Catcher 2. It will be used to navigate user to report page or to show dialog.
      navigatorKey: Catcher2.navigatorKey,
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
            child: TextButton(
                child: Text("Generate error"),
                onPressed: () => generateError()));
  }

  generateError() async {
    throw "Test exception";
  }
}

```
If you run this code you will see screen with "Generate error" button on the screen. 
After clicking on it, it will generate test exception, which will be handled by Catcher 2. Before Catcher 2 process exception to handler, it will
show dialog with information for user. This dialog is shown because we have used DialogReportHandler. Once user confirms action in this dialog,
report will be send to console handler which will log to console error information.

<p align="center">
<img src="https://raw.githubusercontent.com/ThexXTURBOXx/catcher_2/master/screenshots/6.png" width="250px"> <br/> 
  <i>Dialog with default confirmation message</i>
</p>


  
```dart
I/flutter ( 1792): [2023-09-26 20:40:59.075029 | Catcher 2 | INFO] ============================== CATCHER 2 LOG ==============================
I/flutter ( 1792): [2023-09-26 20:40:59.075175 | Catcher 2 | INFO] Crash occurred on 2023-09-26 20:40:57.818695
I/flutter ( 1792): [2023-09-26 20:40:59.075220 | Catcher 2 | INFO]
I/flutter ( 1792): [2023-09-26 20:40:59.075378 | Catcher 2 | INFO] ------- DEVICE INFO -------
I/flutter ( 1792): [2023-09-26 20:40:59.075755 | Catcher 2 | INFO] id: TQ3A.230705.001.B4
I/flutter ( 1792): [2023-09-26 20:40:59.075830 | Catcher 2 | INFO] board: windows
I/flutter ( 1792): [2023-09-26 20:40:59.075874 | Catcher 2 | INFO] bootloader: unknown
I/flutter ( 1792): [2023-09-26 20:40:59.075901 | Catcher 2 | INFO] brand: Windows
I/flutter ( 1792): [2023-09-26 20:40:59.075940 | Catcher 2 | INFO] device: windows_x86_64
I/flutter ( 1792): [2023-09-26 20:40:59.075966 | Catcher 2 | INFO] display: TQ3A.230705.001.B4
I/flutter ( 1792): [2023-09-26 20:40:59.076003 | Catcher 2 | INFO] fingerprint: Windows/windows_x86_64/windows_x86_64:13/TQ3A.230705.001.B4/2307.40000.6.0:user/release-keys
I/flutter ( 1792): [2023-09-26 20:40:59.076047 | Catcher 2 | INFO] hardware: windows_x86_64
I/flutter ( 1792): [2023-09-26 20:40:59.076089 | Catcher 2 | INFO] host: bba7b442c000000
I/flutter ( 1792): [2023-09-26 20:40:59.076169 | Catcher 2 | INFO] isPhysicalDevice: true
I/flutter ( 1792): [2023-09-26 20:40:59.076224 | Catcher 2 | INFO] manufacturer: Microsoft Corporation
I/flutter ( 1792): [2023-09-26 20:40:59.076269 | Catcher 2 | INFO] model: Subsystem for Android(TM)
I/flutter ( 1792): [2023-09-26 20:40:59.076310 | Catcher 2 | INFO] product: windows_x86_64
I/flutter ( 1792): [2023-09-26 20:40:59.076346 | Catcher 2 | INFO] tags: release-keys
I/flutter ( 1792): [2023-09-26 20:40:59.076371 | Catcher 2 | INFO] type: user
I/flutter ( 1792): [2023-09-26 20:40:59.076404 | Catcher 2 | INFO] versionBaseOs:
I/flutter ( 1792): [2023-09-26 20:40:59.076430 | Catcher 2 | INFO] versionCodename: REL
I/flutter ( 1792): [2023-09-26 20:40:59.076462 | Catcher 2 | INFO] versionIncremental: 2307.40000.6.0
I/flutter ( 1792): [2023-09-26 20:40:59.076487 | Catcher 2 | INFO] versionPreviewSdk: 0
I/flutter ( 1792): [2023-09-26 20:40:59.076521 | Catcher 2 | INFO] versionRelease: 13
I/flutter ( 1792): [2023-09-26 20:40:59.076573 | Catcher 2 | INFO] versionSdk: 33
I/flutter ( 1792): [2023-09-26 20:40:59.076611 | Catcher 2 | INFO] versionSecurityPatch: 2023-07-05
I/flutter ( 1792): [2023-09-26 20:40:59.076640 | Catcher 2 | INFO]
I/flutter ( 1792): [2023-09-26 20:40:59.076759 | Catcher 2 | INFO] ------- APP INFO -------
I/flutter ( 1792): [2023-09-26 20:40:59.076829 | Catcher 2 | INFO] environment: debug
I/flutter ( 1792): [2023-09-26 20:40:59.076867 | Catcher 2 | INFO] version: 1.0.0
I/flutter ( 1792): [2023-09-26 20:40:59.076903 | Catcher 2 | INFO] appName: catcher_2_example
I/flutter ( 1792): [2023-09-26 20:40:59.076941 | Catcher 2 | INFO] buildNumber: 1
I/flutter ( 1792): [2023-09-26 20:40:59.076978 | Catcher 2 | INFO] packageName: com.jhomlala.catcher_2_example
I/flutter ( 1792): [2023-09-26 20:40:59.077006 | Catcher 2 | INFO]
I/flutter ( 1792): [2023-09-26 20:40:59.077040 | Catcher 2 | INFO] ---------- ERROR ----------
I/flutter ( 1792): [2023-09-26 20:40:59.077079 | Catcher 2 | INFO] FormatException: Test exception generated by Catcher 2
I/flutter ( 1792): [2023-09-26 20:40:59.077125 | Catcher 2 | INFO]
I/flutter ( 1792): [2023-09-26 20:40:59.077267 | Catcher 2 | INFO] ------- STACK TRACE -------
I/flutter ( 1792): [2023-09-26 20:40:59.077461 | Catcher 2 | INFO] #0      Catcher2.sendTestException (package:catcher_2/core/catcher_2.dart:706:5)
I/flutter ( 1792): [2023-09-26 20:40:59.077523 | Catcher 2 | INFO] #1      ChildWidget.generateError (package:catcher_2_example/main.dart:89:14)
I/flutter ( 1792): [2023-09-26 20:40:59.077562 | Catcher 2 | INFO] #2      _InkResponseState.handleTap (package:flutter/src/material/ink_well.dart:1154:21)
I/flutter ( 1792): [2023-09-26 20:40:59.077588 | Catcher 2 | INFO] #3      GestureRecognizer.invokeCallback (package:flutter/src/gestures/recognizer.dart:275:24)
I/flutter ( 1792): [2023-09-26 20:40:59.077611 | Catcher 2 | INFO] #4      TapGestureRecognizer.handleTapUp (package:flutter/src/gestures/tap.dart:654:11)
I/flutter ( 1792): [2023-09-26 20:40:59.077643 | Catcher 2 | INFO] #5      BaseTapGestureRecognizer._checkUp (package:flutter/src/gestures/tap.dart:311:5)
I/flutter ( 1792): [2023-09-26 20:40:59.077690 | Catcher 2 | INFO] #6      BaseTapGestureRecognizer.handlePrimaryPointer (package:flutter/src/gestures/tap.dart:244:7)
I/flutter ( 1792): [2023-09-26 20:40:59.077719 | Catcher 2 | INFO] #7      PrimaryPointerGestureRecognizer.handleEvent (package:flutter/src/gestures/recognizer.dart:630:9)
I/flutter ( 1792): [2023-09-26 20:40:59.077761 | Catcher 2 | INFO] #8      PointerRouter._dispatch (package:flutter/src/gestures/pointer_router.dart:98:12)
I/flutter ( 1792): [2023-09-26 20:40:59.077811 | Catcher 2 | INFO] #9      PointerRouter._dispatchEventToRoutes.<anonymous closure> (package:flutter/src/gestures/pointer_router.dart:143:9)
I/flutter ( 1792): [2023-09-26 20:40:59.077869 | Catcher 2 | INFO] #10     _LinkedHashMapMixin.forEach (dart:collection-patch/compact_hash.dart:625:13)
I/flutter ( 1792): [2023-09-26 20:40:59.077908 | Catcher 2 | INFO] #11     PointerRouter._dispatchEventToRoutes (package:flutter/src/gestures/pointer_router.dart:141:18)
I/flutter ( 1792): [2023-09-26 20:40:59.077945 | Catcher 2 | INFO] #12     PointerRouter.route (package:flutter/src/gestures/pointer_router.dart:127:7)
I/flutter ( 1792): [2023-09-26 20:40:59.077969 | Catcher 2 | INFO] #13     GestureBinding.handleEvent (package:flutter/src/gestures/binding.dart:488:19)
I/flutter ( 1792): [2023-09-26 20:40:59.078002 | Catcher 2 | INFO] #14     GestureBinding.dispatchEvent (package:flutter/src/gestures/binding.dart:468:22)
I/flutter ( 1792): [2023-09-26 20:40:59.078036 | Catcher 2 | INFO] #15     RendererBinding.dispatchEvent (package:flutter/src/rendering/binding.dart:333:11)
I/flutter ( 1792): [2023-09-26 20:40:59.078077 | Catcher 2 | INFO] #16     GestureBinding._handlePointerEventImmediately (package:flutter/src/gestures/binding.dart:413:7)
I/flutter ( 1792): [2023-09-26 20:40:59.078123 | Catcher 2 | INFO] #17     GestureBinding.handlePointerEvent (package:flutter/src/gestures/binding.dart:376:5)
I/flutter ( 1792): [2023-09-26 20:40:59.078174 | Catcher 2 | INFO] #18     GestureBinding._flushPointerEventQueue (package:flutter/src/gestures/binding.dart:323:7)
I/flutter ( 1792): [2023-09-26 20:40:59.078209 | Catcher 2 | INFO] #19     GestureBinding._handlePointerDataPacket (package:flutter/src/gestures/binding.dart:292:9)
I/flutter ( 1792): [2023-09-26 20:40:59.078250 | Catcher 2 | INFO] #20     _invoke1 (dart:ui/hooks.dart:186:13)
I/flutter ( 1792): [2023-09-26 20:40:59.078286 | Catcher 2 | INFO] #21     PlatformDispatcher._dispatchPointerDataPacket (dart:ui/platform_dispatcher.dart:424:7)
I/flutter ( 1792): [2023-09-26 20:40:59.078310 | Catcher 2 | INFO] #22     _dispatchPointerDataPacket (dart:ui/hooks.dart:119:31)
I/flutter ( 1792): [2023-09-26 20:40:59.078340 | Catcher 2 | INFO]
I/flutter ( 1792): [2023-09-26 20:40:59.078397 | Catcher 2 | INFO] ======================================================================
```
<p align="center">
  <i>Console handler output</i>
</p>

## Catcher 2 usage

### Adding navigator key
In order to make Page Report Mode and Dialog Report Mode work, you must include navigator key. Catcher 2 plugin exposes the key which must be included in your MaterialApp or WidgetApp:

```dart
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //********************************************
      navigatorKey: Catcher2.navigatorKey,
      //********************************************
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: ChildWidget()),
    );
  }

```
You need to provide this key, because Catcher 2 needs context of navigator to show dialogs/pages. There is no need to include this navigator key if you won't use Page/Dialog Report Mode.
You can also provide your own navigator key if need to. You can provide it with Catcher 2 constructor (see below). Please check custom navigator key example to see basic example.

### Catcher 2 configuration
Catcher 2 instance needs rootWidget or runAppFunction in setup time. Please provide one of it.

* rootWidget (optional) - instance of your root application widget
* runAppFunction (optional) - function where runApp() will be called
* debugConfig (optional) - config used when Catcher 2 detects that application runs in debug mode
* releaseConfig (optional) - config used when Catcher 2 detects that application runs in release mode
* profileConfig (optional) - config used when Catcher 2 detects that application runs in profile mode
* enableLogger (optional) - enable/disable internal Catcher 2 logs
* navigatorKey (optional) - provide optional navigator key from outside of Catcher 2
* ensureInitialized (optional) - should Catcher 2 run WidgetsFlutterBinding.ensureInitialized() during initialization

```dart
main() {
  Catcher2Options debugOptions =
  Catcher2Options(DialogReportMode(), [ConsoleHandler()]);
  Catcher2Options releaseOptions = Catcher2Options(DialogReportMode(), [
    EmailManualHandler(["recipient@email.com"])
  ]);
  Catcher2Options profileOptions = Catcher2Options(
    NotificationReportMode(), [ConsoleHandler(), ToastHandler()],
    handlerTimeout: 10000, customParameters: {"example"c: "example_parameter"},);
  Catcher2(rootWidget: MyApp(), debugConfig: debugOptions, releaseConfig: releaseOptions, profileConfig: profileOptions, enableLogger: false, navigatorKey: navigatorKey);
}
```
Catcher2Options parameters:
handlers - list of handlers, which will process report, see handlers to get more information.   
handlerTimeout - timeout in milliseconds, this parameter describes max time of handling report by handler.   
reportMode - describes how error report will be shown to user, see report modes to get more information.   
localizationOptions - translations used by report modes nad report handlers.   
explicitExceptionReportModesMap - explicit report modes map which will be used to trigger specific report mode for specific error.   
explicitExceptionHandlersMap - Explicit report handler map which will be used to trigger specific report report handler for specific error.   
customParameters - map of additional parameters that will be included in report (for example user id or user name).   
handleSilentError - should handle silent errors reported, see FlutterErrorDetails.silent for more details.   
screenshotsPath - path where screenshots will be saved.   
excludedParameters - parameters which will be excluded from report.   
filterFunction - function used to filter errors which shouldn't be handled.   
onFlutterError - additional error handler for Flutter errors. Set this to `FlutterError.onError` when using Catcher 2 within test suites.
onPlatformError - additional error handler for platform errors. Set this to `PlatformDispatcher.instance.onError` when using Catcher 2 within test suites.


### Report caught exception
Catcher 2 won't process exceptions caught in try/catch block. You can send exception from try catch block to Catcher 2:

```dart
try {
  ...
} catch (error,stackTrace) {
  Catcher2.reportCheckedError(error, stackTrace);
}
```

### Localization
Catcher 2 allows to create localizations for Report modes. To add localization support, you need setup
few things:

Add navigatorKey in your `MaterialApp`:
```dart
 navigatorKey: Catcher2.navigatorKey,
```

Add Flutter localizations delegates and locales in your MaterialApp:
```dart
 localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('pl', 'PL'),
      ],
```

Add localizationOptions in `Catcher2Options`:
```dart
Catcher2Options(
...
    localizationOptions: [
        LocalizationOptions("pl", notificationReportModeTitle: "My translation" ...),
        LocalizationOptions("de", notificationReportModeTitle: "My translation" ...),
    ]
)
```

You can add translate for given parameters:
* notificationReportModeTitle - notification report mode title
* notificationReportModeContent - notification report mode subtitle
* dialogReportModeTitle - dialog report mode title
* dialogReportModeDescription - dialog report mode description
* dialogReportModeAccept - dialog report mode accept button
* dialogReportModeCancel - dialog report mode cancel button
* pageReportModeTitle - page report mode toolbar title
* pageReportModeDescription - page report mode description
* pageReportModeAccept - page report mode accept button
* pageReportModeCancel - page report mode cancel button
* toastHandlerDescription - toast handler message


If you want to override default English texts, just simply add localization options for "en" language.

There are build in support for languages:
* english
```dart
LocalizationOptions.buildDefaultEnglishOptions();
```
* chinese
```dart
LocalizationOptions.buildDefaultChineseOptions();
```
* hindi
```dart
LocalizationOptions.buildDefaultHindiOptions();
```
* spanish
```dart
LocalizationOptions.buildDefaultSpanishOptions();
```
* malay
```dart
LocalizationOptions.buildDefaultMalayOptions();
```
* russian
```dart
LocalizationOptions.buildDefaultRussianOptions();
```
* portuguese
```dart
LocalizationOptions.buildDefaultPortugueseOptions();
```
* french
```dart
LocalizationOptions.buildDefaultFrenchOptions();
```
* polish
```dart
LocalizationOptions.buildDefaultPolishOptions();
```
* italian
```dart
LocalizationOptions.buildDefaultItalianOptions();
```
* korean
```dart
LocalizationOptions.buildDefaultKoreanOptions();
```
* german
```dart
LocalizationOptions.buildDefaultGermanOptions();
```
* dutch
```dart
LocalizationOptions.buildDefaultDutchOptions();
```
* arabic
```dart
LocalizationOptions.buildDefaultArabicOptions();
```
* turkish
```dart
LocalizationOptions.buildDefaultTurkishOptions();
```

Complete Example:
```dart
import 'package:flutter/material.dart';
import 'package:catcher_2/catcher_2.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

main() {
  Catcher2Options debugOptions = Catcher2Options(DialogReportMode(), [
    ConsoleHandler(),
    HttpHandler(HttpRequestType.post, Uri.parse("https://httpstat.us/200"),
        printLogs: true)
  ], localizationOptions: [
    LocalizationOptions("pl",
        notificationReportModeTitle: "Wystąpił błąd aplikacji",
        notificationReportModeContent:
            "Naciśnij tutaj aby wysłać raport do zespołu wpsarcia",
        dialogReportModeTitle: "Błąd aplikacji",
        dialogReportModeDescription:
            "Wystąpił niespodziewany błąd aplikacji. Raport z błędem jest gotowy do wysłania do zespołu wsparcia. Naciśnij akceptuj aby wysłać raport lub odrzuć aby odrzucić raport.",
        dialogReportModeAccept: "Akceptuj",
        dialogReportModeCancel: "Odrzuć",
        pageReportModeTitle: "Błąd aplikacji",
        pageReportModeDescription:
            "Wystąpił niespodziewany błąd aplikacji. Raport z błędem jest gotowy do wysłania do zespołu wsparcia. Naciśnij akceptuj aby wysłać raport lub odrzuć aby odrzucić raport.",
        pageReportModeAccept: "Akceptuj",
        pageReportModeCancel: "Odrzuć",
        toastHandlerDescription: "Wystąpił błąd:",
    ) 
  ]);
  Catcher2Options releaseOptions = Catcher2Options(NotificationReportMode(), [
    EmailManualHandler(["recipient@email.com"])
  ]);

  Catcher2(rootWidget: MyApp(), debugConfig: debugOptions, releaseConfig: releaseOptions);
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
      navigatorKey: Catcher2.navigatorKey,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('pl', 'PL'),
      ],
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
        child: TextButton(
            child: Text("Generate error"), onPressed: () => generateError()));
  }

  generateError() async {
    throw "Test exception";
  }
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
Notification Report Mode has been removed because of incompatibility with firebase. Please check local_notifications_example to re-add local notifications to your app.

#### Dialog Report Mode
Dialog Report Mode shows dialog with information about error. Dialog has title, description and 2 buttons: Accept and Cancel. Once user clicks on Accept button, report will be pushed to handlers.

```dart
  ReportMode reportMode = DialogReportMode();
```

See localization options to change default texts.


<p align="center">
<img width="250px" src="https://raw.githubusercontent.com/ThexXTURBOXx/catcher_2/master/screenshots/6.png"><br/>
  <i>Dialog report mode</i>
</p>

#### Page Report Mode
Page Report Mode shows new page with information about error. Page has title, description, stack trace view and 2 buttons: Accept and Cancel. Once user clicks on Accept button, report will be pushed to handlers.

```dart
  ReportMode reportMode = PageReportMode(showStackTrace: false);
```

Page Report Mode can be configured with optional parameters:
showStackTrace (optional) - enables/disables stack trace view  

See localization options to change default texts.


<p align="center">
<img width="250px" src="https://raw.githubusercontent.com/ThexXTURBOXx/catcher_2/master/screenshots/7.png"><br/>
  <i>Page report mode</i>
</p>

### Handlers
Handlers are an last point in error processing flow. They are doing specific tasks with error reports, for example logging report to console.

#### Console Handler


Console Handler is the default and basic handler. It shows crash log in console. Console logger allows you to parametrize log output:

```dart
ConsoleHandler(
          enableApplicationParameters: true,
          enableDeviceParameters: true,
          enableCustomParameters: true,
          enableStackTrace: true,
          handleWhenRejected: false
          )

```

* enableApplicationParameters (optional) - display in log section with application data:

```dart
I/flutter ( 4820): ------- APP INFO -------
I/flutter ( 4820): version: 1.0
I/flutter ( 4820): appName: catcher_2_example
I/flutter ( 4820): buildNumber: 1
I/flutter ( 4820): packageName: com.jhomlala.catcher_2_example
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

* enableCustomParameters (optional) - display in log section with custom parameters passed to Catcher 2 constructor

* enableStackTrace (optional) - display in log section with stack trace:

```dart
I/flutter ( 5073): ------- STACK TRACE -------
I/flutter ( 5073): #0      _MyAppState.generateError (package:catcher_2_example/main.dart:38:5)
I/flutter ( 5073): <asynchronous suspension>
I/flutter ( 5073): #1      _MyAppState.build.<anonymous closure> (package:catcher_2_example/main.dart:31:69)
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

* handleWhenRejected - should report be handled even if user rejects it


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
      printLogs: true)
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
 EmailAutoHandler("smtp.gmail.com", 587, "somefakeemail@gmail.com", "Catcher 2",
          "FakePassword", ["myemail@gmail.com"])
```
We need to setup email smtp server, email account and recipient. Currently, only Gmail was tested and worked. You can try use other email providers, but there can be errors.  

List of all parameters: 
 
* smtpHost (required) - host address of your email, for example host for gmail is smtp.gmail.com  
* smtpPort (required) - smtp port of your email, for example port for gmail is 587  
* senderEmail (required) - email from which Catcher 2 will send email (it will be sender of error emails)  
* senderName (required) - name of sender email
* senderPassword (required) - password for sender email 
* recipients (required) - list which contains recipient emails   
* senderUsername (optional) - set an explicit username for the SMTP authentication
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
<img src="https://raw.githubusercontent.com/ThexXTURBOXx/catcher_2/master/screenshots/3.png">
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
* enableDeviceParameters (optional) - please look in console handler description
* enableApplicationParameters (optional) - please look in console handler description
* enableStackTrace (optional) - please look in console handler description
* enableCustomParameters (optional) - please look in console handler description

You can try using example backend server which handles logs. It's written in Java 8 and Spring Framework and uses material design.
You can find code of backend server here: https://github.com/ThexXTURBOXx/catcher_2/tree/master/backend

<p align="center">
<img src="https://raw.githubusercontent.com/ThexXTURBOXx/catcher_2/master/screenshots/4.png">
</p>

Note: Remember to add Internet permission in Android Manifest:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

#### File Handler
File handler allows to store logs in file. Minimal example:

```dart
main() {
  String path = "/storage/emulated/0/log.txt";
  Catcher2Options debugOptions = Catcher2Options(
      DialogReportMode(), [FileHandler(File(path), printLogs: true)]);
  Catcher2Options releaseOptions =
      Catcher2Options(DialogReportMode(), [FileHandler(File(path))]);

  Catcher2(rootWidget: MyApp(), debugConfig: debugOptions, releaseConfig: releaseOptions);
}
```

All parameters list:  
* file (required) - the file where you want to store your logs
* enableDeviceParameters (optional) - please look in console handler description   
* enableApplicationParameters (optional) - please look in console handler description  
* enableStackTrace (optional) - please look in console handler description  
* enableCustomParameters (optional) - please look in console handler description  
* printLogs (optional) - enable/disable debug logs
* handleWhenRejected - please look in console handler description

Example of logging to file in external directory: https://github.com/ThexXTURBOXx/catcher_2/blob/master/example/lib/file_example.dart

If you want to get file path with path_provider lib, you need to call Catcher 2 constructor with
ensureInitialized = true. Then you need to pass your catcher 2 config with updateConfig.
This is required because WidgetBindings ensureInitialized must be called first before accessing
path_provider methods.
See example here: https://github.com/ThexXTURBOXx/catcher_2/blob/master/example/lib/file_example.dart

#### Toast Handler
Toast handler allows to show short message in toast. Minimal example:

All parameters list:
* gravity (optional) - location of the toast on screen top/middle/bottom
* length (optional) - length of toast: long or short
* backgroundColor (optional) - background color of toast
* textColor (optional) - text color of toast
* fontSize (optional) - text size
* customMessage (optional) - custom message for toast, if not set then "Error occurred: error" will be displayed.
* handleWhenRejected - please look in console handler description

<p align="center">
<img src="https://raw.githubusercontent.com/ThexXTURBOXx/catcher_2/master/screenshots/5.png" width="250px">
</p>

#### Sentry Handler
Sentry handler allows to send handled errors to Sentry.io. Before using sentry handler, you need to create your project in
Sentry.io page and then copy DSN link. Example:

```dart
main() {

  Catcher2Options debugOptions = Catcher2Options(
      DialogReportMode(), [SentryHandler(SentryClient("YOUR_DSN_HERE"))]);
  Catcher2Options releaseOptions = Catcher2Options(NotificationReportMode(), [
    EmailManualHandler(["recipient@email.com"])
  ]);

  Catcher2(rootWidget: MyApp(), debugConfig: debugOptions, releaseConfig: releaseOptions);
}
```

All parameters list:
* sentryClient - sentry client instance
* enableDeviceParameters (optional) - please look in console handler description
* enableApplicationParameters (optional) - please look in console handler description
* enableCustomParameters (optional) - please look in console handler description
* customEnvironment (optional) - custom environment string, if null, Catcher 2 will generate it
* customRelease (optional) - custom release string , if null, Catcher 2 will generate it
* printLogs (optional) - enable/disable debug logs

#### Slack Handler
Slack Handler allows to send messages to your Slack workspace. You can specify destination
of your message and format. You need to register webhook in your workspace to make this handler
works: https://api.slack.com/incoming-webhooks.

```dart
main() {

 Catcher2Options debugOptions = Catcher2Options(SilentReportMode(), [
     SlackHandler(
         "<web_hook_url>",
         "#catcher2",
         username: "Catcher2Test",
         iconEmoji: ":thinking_face:",
         enableDeviceParameters: true,
         enableApplicationParameters: true,
         enableCustomParameters: true,
         enableStackTrace: true,
         printLogs: true),
   ]);
   Catcher2(rootWidget: MyApp(), debugConfig: debugOptions);
}
```

All parameters list:
* webhookUrl (required) - url of your webhook
* channel (required) - your channel name (i.e. #catcher2)
* username (optional) - name of the integration bot
* iconEmoji (optional) - avatar of the integration bot
* enableDeviceParameters (optional) - please look in console handler description
* enableApplicationParameters (optional) - please look in console handler description
* enableCustomParameters (optional) - please look in console handler description
* enableStackTrace (optional) - please look in console handler description
* printLogs (optional) - enable/disable debug logs
* customMessageBuilder - provide custom message

#### Discord Handler
Discord Handler allows to send messages to your Discord workspace. You need to register webhook in your server to make this handler
works: https://support.discordapp.com/hc/en-us/articles/228383668-Intro-to-Webhooks.

```dart
main() {
 Catcher2Options debugOptions = Catcher2Options(SilentReportMode(), [
     DiscordHandler(
         "<web_hook_url>",
         enableDeviceParameters: true,
         enableApplicationParameters: true,
         enableCustomParameters: true,
         enableStackTrace: true,
         printLogs: true),
   ]);

   Catcher2(rootWidget: MyApp(), debugConfig: debugOptions);
}
```

All parameters list:
* webhookUrl (required) - url of your webhook
* enableDeviceParameters (optional) - please look in console handler description
* enableApplicationParameters (optional) - please look in console handler description
* enableCustomParameters (optional) - please look in console handler description
* enableStackTrace (optional) - please look in console handler description
* printLogs (optional) - enable/disable debug logs
* customMessageBuilder - provide custom message


### Snackbar Handler
Snackbar handler allows to show customized snackbar message.

```dart
void main() {
  Catcher2Options debugOptions = Catcher2Options(DialogReportMode(), [
    SnackbarHandler(
      Duration(seconds: 5),
      backgroundColor: Colors.green,
      elevation: 2,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
          label: "Button",
          onPressed: () {
            print("Click!");
          }),
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
  ]);

  Catcher2(
    runAppFunction: () {
      runApp(MyApp());
    },
    debugConfig: debugOptions,
  );
}
```

All parameters list:
* duration - See [SnackBar] in Flutter docs for details.
* backgroundColor - See [SnackBar] in Flutter docs for details.
* elevation - See [SnackBar] in Flutter docs for details.
* margin - See [SnackBar] in Flutter docs for details.
* padding - See [SnackBar] in Flutter docs for details.
* width - See [SnackBar] in Flutter docs for details.
* shape - See [SnackBar] in Flutter docs for details.
* behavior - See [SnackBar] in Flutter docs for details.
* action - See [SnackBar] in Flutter docs for details.
* animation - See [SnackBar] in Flutter docs for details.
* onVisible - See [SnackBar] in Flutter docs for details.
* customMessage - Custom message which can be displayed instead default one.
* textStyle - Custom text style for text displayed within snackbar.
* printLogs - Enable additional logs printing


#### Crashlytics Handler
Crashlytics handler has been removed from core package. You can re-enable it in your project by using custom report mode presented in crashlytics_example in example project.


### Explicit exception report handler map
Explicit exception report handler map allows you to setup report handler for specific exception. For example if you want to setup Console Handler for FormatException, you can write:
```dart
var explicitMap = {"FormatException": ConsoleHandler()};
Catcher2Options debugOptions = Catcher2Options(
      DialogReportMode(),
      [
        ConsoleHandler(),
        HttpHandler(HttpRequestType.post, Uri.parse("https://httpstat.us/200"),
            printLogs: true)
      ],
      explicitExceptionHandlersMap: explicitMap);
```

Now if `FormatException` will be caught, then Console Handler will be used. Warning: if you setup explicit exception map for specific exception, then only this handler will be used for this exception!

### Explicit exception report mode map
Same as explicit report handler map, but it's for report mode. Let's say you want to use specific report mode for some exception:
```dart
 var explicitReportModesMap = {"FormatException": NotificationReportMode()};
  Catcher2Options debugOptions = Catcher2Options(
      DialogReportMode(),
      [
        ConsoleHandler(),
        HttpHandler(HttpRequestType.post, Uri.parse("https://httpstat.us/200"),
            printLogs: true)
      ],
      explicitExceptionReportModesMap: explicitReportModesMap,);
```
When `FormatException` will be caught, then NotificationReportMode will be used. For other exceptions, Catcher 2 will use DialogReportMode.



### Error widget
You can add error widget which will replace red screen of death. To add this into your app, see code below:
```dart
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Catcher2.navigatorKey,
      //********************************************
      builder: (BuildContext context, Widget widget) {
        Catcher2.addDefaultErrorWidget(
            showStacktrace: true,
            title: "Custom error title",
            description: "Custom error description",
            maxWidthForSmallMode: 150);
        return widget;
      },
      //********************************************
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: ChildWidget()),
    );
  }
```
You need to add in your MaterialApp or CupertinoApp builder method with ```Catcher2.addDefaultErrorWidget()```. This will add error handler for each widget in your app.

You can provide optional parameters:
* showStacktrace - show/hide stacktrace
* title - custom title for error widget
* description - custom description for error widget
* maxWidthForSmallMode - max width for "small" mode, default is 150

Error widget will replace your widget if he fails to render. If width of widget is less than maxWidthForSmallMode then "small" mode will be enabled, which will show only error icon

<p align="center">
<table>
	<tr>
		<td>With error widget</td><td>Without error widget</td>
	</tr>
		<tr>
		<td><img src="https://raw.githubusercontent.com/ThexXTURBOXx/catcher_2/master/screenshots/8.png" width="250px"></td><td><img src="https://raw.githubusercontent.com/ThexXTURBOXx/catcher_2/master/screenshots/9.png" width="250px"></td>
	</tr>
 </table>
</p>

### Current config
You can get currently used config by using:
```dart
Catcher2Options options = catcher2.getCurrentConfig();
```
This can be used for example to change custom parameters in runtime.

### Test exception
Send test exception:

```dart
Catcher2.sendTestException();
```

### Update config
You can update Catcher 2 config during runtime:
```dart
/// Catcher 2 instance initialized
Catcher2 catcher2;
catcher2.updateConfig(
     debugConfig: Catcher2Options(
       PageReportMode(),
       [ConsoleHandler()],
     ),
   );
```

### Screenshots
Catcher 2 can create screenshots automatically and include them in report handlers. To add screenshot
support in your app, simply wrap your root widget with Catcher2Screenshot widget:
```dart
MaterialApp(
      navigatorKey: Catcher2.navigatorKey,
      home: Catcher2Screenshot(
        catcher2: Catcher2.getInstance(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: ChildWidget(),
        ),
      ),
    );
```
Also you need to provide directory path, where Catcher 2 will store screenshot files: 

```dart
  Catcher2Options debugOptions = Catcher2Options(
    DialogReportMode(),
    [
      ToastHandler(),
    ],
    screenshotsPath: path,
  );
```
Screenshots will work for all platforms, except Web. Screenshots will work in:
* Http Handler
* Email auto handler
* Email manual handler
* Discord

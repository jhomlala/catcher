## 0.5.0
* Added null safety.

## 0.4.1
* Added localization text in toast handler.
* Fixed page report mode UI issues by Don Coleman (https://github.com/drcdev).
* Added handleSilentError parameter in CatcherOptions.
* [BREAKING_CHANGE] PlatformType values has been changed to lower camel case.
* Lint fixes.

## 0.4.0
* [BREAKING_CHANGE]: rootWidget parameter has been moved to optional parameter
* Catcher requires now rootWidget or runAppFunction in setup
* Introduced CI and Lint check
* Updated sentry version by Nico Mexis (https://github.com/ThexXTURBOXx)

## 0.3.23
* Updated device_info version

## 0.3.22
* Added enableCustomParameters, enableStackTrace, enableApplicationParameters, enableDeviceParameters to HttpHandler

## 0.3.21
* Added Dutch language by EpicOkapi (https://github.com/EpicOkapi)
* Modified SentryHandler's userContext parameter by Mari Thorsteinsen (https://github.com/marantho)
* Updated dependencies

## 0.3.20
* Added customEnvironment and customRelease settings for Sentry Handler
* Updated documentation
* Fixed dependencies declaration

## 0.3.19
* Added detailed logs for sentry handler

## 0.3.18
* Added ensureInitialized flag in Catcher constructor
* Added updateConfig method to update configuration in runtime

## 0.3.17
* Updated documentation

## 0.3.16
* [BREAKING_CHANGE] Reverted crashlytics handler from core package
* Updated dependencies

## 0.3.15
* Added user context in sentry handler by Roman Muratov (https://github.com/kasl)
* Added crashlytics handler

## 0.3.14
* General refactor
* [BREAKING_CHANGE] You should use import "import 'package:catcher/catcher.dart';" instead import 'package:catcher/catcher_plugin.dart';

## 0.3.13
* Fixed pub dev score error

## 0.3.12
* Fixed pub dev score error
* Fixed min dart version

## 0.3.11
* Fixed pub dev score error

## 0.3.10
* Fixed pub dev score error

## 0.3.9
* Fixed pub dev score error

## 0.3.8
* Updated file handler example
* Allowed to update headers of http handler in runtime
* Updated flutter_html dependency

## 0.3.7
* Added Web support
* [BREAKING CHANGE] Added new abstract method (getSupportPlatform) for ReportHandler and ReportMode
* General refactor

## 0.3.6
* Removed Android lifecycle plugin
* Fixed Android class (support for v2 FlutterPlugin)

## 0.3.5
* Use Android Lifecycle flutter_plugin_android_lifecycle by Dlani (https://github.com/dlanileonardo)
* Pass ErrorDetails for Report, to use in CustomErrorHandler by Dlani (https://github.com/dlanileonardo)
* Added support for cupertino apps

## 0.3.4
* Fixed typos by Rob Halff (https://github.com/rhalff)
* [BREAKING CHANGE] Changed customTitle to title and customDescription to description in error widget.
* Added support for using error widget in small widgets.
* Refactored classes and added proper input handling.
* Fixed HttpHandler headers.
* Fixed AndroidX support.

## 0.3.3
* Updated dependencies
* Prepare for 1.0.0 version of sensors and package_info. ([dart_lsc](https://github.com/amirh/dart_lsc))

## 0.3.2
* Removed invalid import from error widget

## 0.3.1
* Fixed sentry handler reporting by David Martos (https://github.com/davidmartos96)
* Fixed stack trace displaying in error widget by Andrious Solutions (https://github.com/Andrious)

## 0.3.0
* Fixed AndroidX issues
* Changed sentry handler to accept sentry client instead of dsn

## 0.2.9
* Fixed localization options not initializing correctly

## 0.2.8
* [BREAKING CHANGE] Removed local notifications report mode due to incompatible with firebase_messaging. Check local_notifications_example to re-add local notifications to your app.
* More sentry handler customization
* Added support for custom navigator key provided from outside of Catcher
* Updated gradle version and min sdk version (android)
* Updated dependencies versions

## 0.2.7
* Fix for theme problem in error widget

## 0.2.6
* Added context required flag to report mode. Reason for that is to build custom report modes with context

## 0.2.5
* Fixed Dio version
* Updated portuguese translation by Estevão Costa (https://github.com/estevao90)

## 0.2.4
* Fixed Dio API breaking change

## 0.2.3
* Added Korean translations by Jace Shim (https://github.com/jaceshim)

## 0.2.2
* Added Slack handler
* Added Discord handler

## 0.2.1
* Added getCurrentConfig() method in Catcher class.
* Updated dependencies

## 0.2.0
* Updated Dio and Mailer version
* Refactored auto email handler

## 0.1.9
* Fixed custom parameters in email manual handler and email auto handler
* Added sentry handler

## 0.1.8
* Added explicit report mode map feature

## 0.1.7
* Added error widget feature

## 0.1.6
* Updated dependencies

## 0.1.5
* Fixed debugLock error
* Added flag to switch Catcher logger on/off

## 0.1.4
* Added explicit exception report handler map feature

## 0.1.3
* Added italian translations

## 0.1.2
* Updated chinese translations (Catcher is now using simplified chinese)

## 0.1.1
* Added test exception

## 0.1.0
* Finished basic API
* Added localization feature

## 0.0.12
* Fixed notification report mode bug

## 0.0.11
* [BREAKING CHANGE] Updated dependency libs to support AndroidX

## 0.0.10
* Fixed texts in report modes
* Fixed cached error report feature

## 0.0.9
* Updated Dio to version 2.0.0

## 0.0.8
* Added email manual handler
* Changed email handler to email auto handler
* Added application profile feature
* Added page report mode feature
* Added dialog report mode feature
* Changed configuration step, it uses now CatcherOptions to setup config for specific profile


## 0.0.7
* Fixed import error

## 0.0.6
* Fixed EmailHandler error

## 0.0.5
* Code refactor

## 0.0.4

* Created initial release

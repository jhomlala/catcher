/// Library for error catching which provides multiple handlers for dealing with
/// errors when they are not caught by the developer.
library catcher_2;

export 'package:catcher_2/core/catcher_2.dart';
export 'package:catcher_2/core/catcher_2_screenshot.dart';
export 'package:catcher_2/handlers/console_handler.dart';
export 'package:catcher_2/handlers/discord_handler.dart';
export 'package:catcher_2/handlers/email_auto_handler.dart';
export 'package:catcher_2/handlers/email_manual_handler.dart';
export 'package:catcher_2/handlers/file_handler.dart';
export 'package:catcher_2/handlers/http_handler.dart';
export 'package:catcher_2/handlers/sentry_handler.dart';
export 'package:catcher_2/handlers/slack_handler.dart';
export 'package:catcher_2/handlers/snackbar_handler.dart';
export 'package:catcher_2/handlers/toast_handler.dart';
export 'package:catcher_2/mode/dialog_report_mode.dart';
export 'package:catcher_2/mode/page_report_mode.dart';
export 'package:catcher_2/mode/report_mode_action_confirmed.dart';
export 'package:catcher_2/mode/silent_report_mode.dart';
export 'package:catcher_2/model/catcher_2_options.dart';
export 'package:catcher_2/model/http_request_type.dart';
export 'package:catcher_2/model/localization_options.dart';
export 'package:catcher_2/model/report.dart';
export 'package:catcher_2/model/report_handler.dart';
export 'package:catcher_2/model/report_mode.dart';
export 'package:catcher_2/model/toast_handler_gravity.dart';
export 'package:catcher_2/model/toast_handler_length.dart';
export 'package:catcher_2/utils/catcher_2_logger.dart';

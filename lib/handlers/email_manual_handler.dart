import 'package:catcher_2/handlers/base_email_handler.dart';
import 'package:catcher_2/model/platform_type.dart';
import 'package:catcher_2/model/report.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:material_ui/material_ui.dart';

class EmailManualHandler extends BaseEmailHandler {
  EmailManualHandler(
    this.recipients, {
    this.sendHtml = true,
    this.printLogs = false,
    super.emailTitle,
    super.emailHeader,
    super.enableDeviceParameters = true,
    super.enableApplicationParameters = true,
    super.enableStackTrace = true,
    super.enableCustomParameters = true,
  }) : assert(recipients.isNotEmpty, "Recipients can't be empty");
  final List<String> recipients;
  final bool sendHtml;
  final bool printLogs;

  @override
  Future<bool> handle(Report report, BuildContext? context) async =>
      _sendEmail(report);

  Future<bool> _sendEmail(Report report) async {
    try {
      final attachments = <String>[];
      XFile? screenshot = report.screenshot;
      if (screenshot != null && screenshot is FileSystemXFile) {
        attachments.add(screenshot.path);
      }

      final mailOptions = MailOptions(
        body: _getEmailBody(report),
        subject: getEmailTitle(report),
        recipients: recipients,
        isHTML: sendHtml,
        attachments: attachments,
      );
      _printLog('Creating mail request');
      await FlutterMailer.send(mailOptions);
      _printLog('Creating mail request success');
      return true;
    } catch (exc, stackTrace) {
      _printLog('Exception occurred: $exc stack: $stackTrace');
      return false;
    }
  }

  String _getEmailBody(Report report) {
    if (sendHtml) {
      return setupHtmlMessageText(report);
    } else {
      return setupRawMessageText(report);
    }
  }

  void _printLog(String log) {
    if (printLogs) {
      logger.info(log);
    }
  }

  @override
  List<PlatformType> getSupportedPlatforms() => [
    PlatformType.android,
    PlatformType.iOS,
  ];
}

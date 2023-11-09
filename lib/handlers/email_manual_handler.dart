import 'package:catcher/handlers/base_email_handler.dart';
import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

class EmailManualHandler extends BaseEmailHandler {
  final List<String> recipients;
  final bool sendHtml;
  final bool printLogs;

  EmailManualHandler(
    this.recipients, {
    this.sendHtml = true,
    this.printLogs = false,
    String? emailTitle,
    String? emailHeader,
    bool enableDeviceParameters = true,
    bool enableApplicationParameters = true,
    bool enableStackTrace = true,
    bool enableCustomParameters = true,
  })  : assert(recipients.isNotEmpty, "Recipients can't be null or empty"),
        super(
          enableDeviceParameters,
          enableApplicationParameters,
          enableStackTrace,
          enableCustomParameters,
          emailTitle,
          emailHeader,
        );

  @override
  Future<bool> handle(Report report, BuildContext? context) async {
    return _sendEmail(report);
  }

  Future<bool> _sendEmail(Report report) async {
    try {
      final mailOptions = MailOptions(
        body: _getEmailBody(report),
        subject: getEmailTitle(report),
        recipients: recipients,
        isHTML: sendHtml,
        attachments: [
          report.screenshot?.path ?? '',
        ],
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

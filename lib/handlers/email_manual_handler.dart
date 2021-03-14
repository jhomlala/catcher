import 'package:catcher/handlers/base_email_handler.dart';
import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:logging/logging.dart';

class EmailManualHandler extends BaseEmailHandler {
  final List<String> recipients;
  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableStackTrace;
  final bool enableCustomParameters;
  final String? emailTitle;
  final String? emailHeader;
  final bool sendHtml;
  final bool printLogs;
  final Logger _logger = Logger("EmailManualHandler");

  EmailManualHandler(
    this.recipients, {
    this.enableDeviceParameters = true,
    this.enableApplicationParameters = true,
    this.enableStackTrace = true,
    this.enableCustomParameters = true,
    this.emailTitle,
    this.emailHeader,
    this.sendHtml = true,
    this.printLogs = false,
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
  Future<bool> handle(Report report) async {
    return _sendEmail(report);
  }

  Future<bool> _sendEmail(Report report) async {
    try {
      final MailOptions mailOptions = MailOptions(
        body: _getEmailBody(report),
        subject: getEmailTitle(report),
        recipients: recipients,
        isHTML: sendHtml,
      );
      _printLog("Creating mail request");
      await FlutterMailer.send(mailOptions);
      _printLog("Creating mail request success");
      return true;
    } catch (exc, stackTrace) {
      _printLog("Exception occurred: $exc stack: $stackTrace");
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
      _logger.info(log);
    }
  }

  @override
  List<PlatformType> getSupportedPlatforms() => [
        PlatformType.android,
        PlatformType.iOS,
      ];
}

import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:catcher/model/report_handler.dart';
import 'package:logging/logging.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailAutoHandler extends ReportHandler {
  final String smtpHost;
  final int smtpPort;
  final String senderEmail;
  final String senderName;
  final String senderPassword;
  final bool enableSsl;
  final List<String> recipients;
  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableStackTrace;
  final bool enableCustomParameters;
  final String? emailTitle;
  final String? emailHeader;
  final bool sendHtml;
  final bool printLogs;
  final Logger _logger = Logger("EmailAutoHandler");

  EmailAutoHandler(
    this.smtpHost,
    this.smtpPort,
    this.senderEmail,
    this.senderName,
    this.senderPassword,
    this.recipients, {
    this.enableSsl = false,
    this.enableDeviceParameters = true,
    this.enableApplicationParameters = true,
    this.enableStackTrace = true,
    this.enableCustomParameters = true,
    this.emailTitle,
    this.emailHeader,
    this.sendHtml = true,
    this.printLogs = false,
  }) : assert(recipients.isNotEmpty, "Recipients can't be null or empty");

  @override
  Future<bool> handle(Report error) {
    return _sendMail(error);
  }

  Future<bool> _sendMail(Report report) async {
    try {
      final message = Message()
        ..from = Address(senderEmail, senderName)
        ..recipients.addAll(recipients)
        ..subject = _getEmailTitle(report)
        ..text = _setupRawMessageText(report);

      if (sendHtml) {
        message.html = _setupHtmlMessageText(report);
      }
      _printLog("Sending email...");

      final result = await send(message, _setupSmtpServer());

      _printLog("Email result: mail: ${result.mail} "
          "sending start time: ${result.messageSendingStart} "
          "sending end time: ${result.messageSendingEnd}");

      return true;
    } catch (stacktrace, exception) {
      _printLog(stacktrace.toString());
      _printLog(exception.toString());
      return false;
    }
  }

  SmtpServer _setupSmtpServer() {
    return SmtpServer(smtpHost,
        port: smtpPort,
        ssl: enableSsl,
        username: senderEmail,
        password: senderPassword);
  }

  String? _getEmailTitle(Report report) {
    if (emailTitle?.isNotEmpty == true) {
      return emailTitle;
    } else {
      return "Error report: >> ${report.error} <<";
    }
  }

  String _setupHtmlMessageText(Report report) {
    final StringBuffer buffer = StringBuffer();
    if (emailHeader?.isNotEmpty == true) {
      buffer.write(emailHeader);
      buffer.write("<hr><br>");
    }

    buffer.write("<h2>Error:</h2>");
    buffer.write(report.error.toString());
    buffer.write("<hr><br>");
    if (enableStackTrace) {
      buffer.write("<h2>Stack trace:</h2>");
      buffer.write(report.stackTrace.toString().replaceAll("\n", "<br>"));
      buffer.write("<hr><br>");
    }
    if (enableDeviceParameters) {
      buffer.write("<h2>Device parameters:</h2>");
      for (final entry in report.deviceParameters.entries) {
        buffer.write("<b>${entry.key}</b>: ${entry.value}<br>");
      }
      buffer.write("<hr><br>");
    }
    if (enableApplicationParameters) {
      buffer.write("<h2>Application parameters:</h2>");
      for (final entry in report.applicationParameters.entries) {
        buffer.write("<b>${entry.key}</b>: ${entry.value}<br>");
      }
      buffer.write("<br><br>");
    }

    if (enableCustomParameters) {
      buffer.write("<h2>Custom parameters:</h2>");
      for (final entry in report.customParameters.entries) {
        buffer.write("<b>${entry.key}</b>: ${entry.value}<br>");
      }
      buffer.write("<br><br>");
    }

    return buffer.toString();
  }

  String _setupRawMessageText(Report report) {
    final StringBuffer buffer = StringBuffer();
    if (emailHeader?.isNotEmpty == true) {
      buffer.write(emailHeader);
      buffer.write("\n\n");
    }

    buffer.write("Error:\n");
    buffer.write(report.error.toString());
    buffer.write("\n\n");
    if (enableStackTrace) {
      buffer.write("Stack trace:\n");
      buffer.write(report.stackTrace.toString());
      buffer.write("\n\n");
    }
    if (enableDeviceParameters) {
      buffer.write("Device parameters:\n");
      for (final entry in report.deviceParameters.entries) {
        buffer.write("${entry.key}: ${entry.value}\n");
      }
      buffer.write("\n\n");
    }
    if (enableApplicationParameters) {
      buffer.write("Application parameters:\n");
      for (final entry in report.applicationParameters.entries) {
        buffer.write("${entry.key}: ${entry.value}\n");
      }
      buffer.write("\n\n");
    }
    if (enableCustomParameters) {
      buffer.write("Custom parameters:\n");
      for (final entry in report.customParameters.entries) {
        buffer.write("${entry.key}: ${entry.value}\n");
      }
      buffer.write("\n\n");
    }
    return buffer.toString();
  }

  void _printLog(String log) {
    if (printLogs) {
      _logger.info(log);
    }
  }

  @override
  List<PlatformType> getSupportedPlatforms() =>
      [PlatformType.android, PlatformType.iOS];
}

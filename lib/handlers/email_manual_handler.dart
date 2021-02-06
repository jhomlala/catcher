import 'package:catcher/model/platform_type.dart';
import 'package:catcher/model/report.dart';
import 'package:catcher/model/report_handler.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:logging/logging.dart';

class EmailManualHandler extends ReportHandler {
  final List<String> recipients;
  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableStackTrace;
  final bool enableCustomParameters;
  final String emailTitle;
  final String emailHeader;
  final bool sendHtml;
  final bool printLogs;
  final Logger _logger = Logger("EmailManualHandler");

  EmailManualHandler(this.recipients,
      {this.enableDeviceParameters = true,
      this.enableApplicationParameters = true,
      this.enableStackTrace = true,
      this.enableCustomParameters = true,
      this.emailTitle,
      this.emailHeader,
      this.sendHtml = true,
      this.printLogs = false})
      : assert(recipients != null && recipients.isNotEmpty,
            "Recipients can't be null or empty"),
        assert(enableDeviceParameters != null,
            "enableDeviceParameters can't be null"),
        assert(enableApplicationParameters != null,
            "enableApplicationParameters can't be null"),
        assert(enableStackTrace != null, "enableStackTrace can't be null"),
        assert(enableCustomParameters != null,
            "enableCustomParameters can't be null"),
        assert(sendHtml != null, "sendHtml can't be null"),
        assert(printLogs != null, "printLogs can't be null");

  @override
  Future<bool> handle(Report report) async {
    return _sendEmail(report);
  }

  Future<bool> _sendEmail(Report report) async {
    try {
      final MailOptions mailOptions = MailOptions(
        body: _getBody(report),
        subject: _getTitle(report),
        recipients: recipients,
        isHTML: sendHtml,
      );
      _printLog("Creating mail request");
      await FlutterMailer.send(mailOptions);
      _printLog("Creating mail request success");
      return true;
    } catch (exc, stackTrace) {
      _printLog("Exception occured: $exc stack: $stackTrace");
      return false;
    }
  }

  String _getTitle(Report report) {
    if (emailTitle != null && emailTitle.isNotEmpty) {
      return emailTitle;
    } else {
      return "Error report: >> ${report.error} <<";
    }
  }

  String _getBody(Report report) {
    if (sendHtml) {
      return _setupHtmlMessageText(report);
    } else {
      return _setupRawMessageText(report);
    }
  }

  String _setupHtmlMessageText(Report report) {
    final StringBuffer buffer = StringBuffer();
    if (emailHeader != null && emailHeader.isNotEmpty) {
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
    if (emailHeader != null && emailHeader.isNotEmpty) {
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

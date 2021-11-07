import 'dart:convert';

import 'package:catcher/model/report.dart';
import 'package:catcher/model/report_handler.dart';

///Base class for all email handlers.
abstract class BaseEmailHandler extends ReportHandler {
  final bool enableDeviceParameters;
  final bool enableApplicationParameters;
  final bool enableStackTrace;
  final bool enableCustomParameters;
  final String? emailTitle;
  final String? emailHeader;
  final HtmlEscape _htmlEscape = const HtmlEscape();

  BaseEmailHandler(
    this.enableDeviceParameters,
    this.enableApplicationParameters,
    this.enableStackTrace,
    this.enableCustomParameters,
    this.emailTitle,
    this.emailHeader,
  );

  ///Setup email title from [report].
  String getEmailTitle(Report report) {
    if (emailTitle?.isNotEmpty == true) {
      return emailTitle!;
    } else {
      return "Error report: >> ${report.error} <<";
    }
  }

  ///Setup html email message from [report].
  String setupHtmlMessageText(Report report) {
    final StringBuffer buffer = StringBuffer();
    if (emailHeader?.isNotEmpty == true) {
      buffer.write(_escapeHtmlValue(emailHeader ?? ""));
      buffer.write("<hr><br>");
    }

    buffer.write("<h2>Error:</h2>");
    buffer.write(_escapeHtmlValue(report.error.toString()));
    buffer.write("<hr><br>");
    if (enableStackTrace) {
      buffer.write("<h2>Stack trace:</h2>");

      _escapeHtmlValue(report.stackTrace.toString())
          .split("\n")
          .forEach((element) {
        buffer.write("$element<br>");
      });
      buffer.write("<hr><br>");
    }
    if (enableDeviceParameters) {
      buffer.write("<h2>Device parameters:</h2>");
      for (final entry in report.deviceParameters.entries) {
        buffer
            .write("<b>${entry.key}</b>: ${_escapeHtmlValue(entry.value)}<br>");
      }
      buffer.write("<hr><br>");
    }
    if (enableApplicationParameters) {
      buffer.write("<h2>Application parameters:</h2>");
      for (final entry in report.applicationParameters.entries) {
        buffer
            .write("<b>${entry.key}</b>: ${_escapeHtmlValue(entry.value)}<br>");
      }
      buffer.write("<br><br>");
    }

    if (enableCustomParameters) {
      buffer.write("<h2>Custom parameters:</h2>");
      for (final entry in report.customParameters.entries) {
        buffer
            .write("<b>${entry.key}</b>: ${_escapeHtmlValue(entry.value)}<br>");
      }
      buffer.write("<br><br>");
    }

    return buffer.toString();
  }

  ///Escape html value from [value].
  String _escapeHtmlValue(dynamic value) {
    return _htmlEscape.convert(value.toString());
  }

  ///Setup raw text email message from [report].
  String setupRawMessageText(Report report) {
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
}

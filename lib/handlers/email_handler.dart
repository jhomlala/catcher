import 'package:catcher/report.dart';
import 'package:catcher/handlers/report_handler.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:meta/meta.dart';

class EmailHandler extends ReportHandler {
  final String smtpHost;
  final int smtpPort;
  final String username;
  final String password;
  final bool enableSsl;
  final List<String> recipients;

  const EmailHandler(
      {@required this.smtpHost,
      @required this.smtpPort,
      @required this.username,
      @required this.password,
      this.enableSsl = false,
      @required this.recipients});

  @override
  bool handle(Report error) {
    _sendMail(error);
    return true;
  }
  _sendMail(Report report) async {


    // Create our message.
    final message = new Message()
      ..from = new Address(this.username, "Catcher Flutter")
      ..recipients.addAll(recipients)
      ..subject = "Crash: ${report.error}"
      ..text = _setupMessageText(report);

    print("Sending email!!!");
    final sendReports = await send(message, _setupSmtpServer());


    /*print("Send: " +
        sendReports[0].sent.toString() +
        "code: " +
        sendReports[0].validationProblems[0].code +
        " problems: " +
        sendReports[0].validationProblems[0].msg);*/

    return true;
  }

  SmtpServer _setupSmtpServer() {
    return SmtpServer(smtpHost,
        port: smtpPort, ssl: enableSsl, username: username, password: password);
  }

  String _setupMessageText(Report report){
    StringBuffer buffer = StringBuffer("");
    buffer.write("Error:\n");
    buffer.write(report.error.toString());
    buffer.write("\n\n");
    buffer.write("Stack trace:\n");
    buffer.write(report.stackTrace.toString());
    buffer.write("\n\n");
    buffer.write("Device info:\n");
    for (var entry in report.deviceParameters.entries){
      buffer.write("${entry.key}: ${entry.value}\n");
    }
    buffer.write("\n\n");
    buffer.write("Application info:\n");
    for (var entry in report.applicationParameters.entries){
      buffer.write("${entry.key}: ${entry.value}\n");
    }
    buffer.write("\n");
    return buffer.toString();
  }

}

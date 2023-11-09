import 'package:logging/logging.dart';

///Class used to provide logger for Catcher.
class CatcherLogger {
  final Logger _logger = Logger('Catcher');

  ///Setup logger configuration.
  void setup() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen(
      (LogRecord rec) {
        // ignore: avoid_print
        print(
          '[${rec.time} | ${rec.loggerName} | ${rec.level.name}] '
          '${rec.message}',
        );
      },
    );
  }

  ///Log info message.
  void info(String message) {
    _logger.info(message);
  }

  ///Log fine message.
  void fine(String message) {
    _logger.fine(message);
  }

  ///Log warning message.
  void warning(String message) {
    _logger.warning(message);
  }

  ///Log severe mesasge.
  void severe(String message) {
    _logger.severe(message);
  }
}

import 'package:logging/logging.dart';

/// Class used to provide logger for Catcher 2.
class Catcher2Logger {
  final Logger _logger = Logger('Catcher 2');

  /// Setup logger configuration.
  void setup() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen(
      (rec) {
        // ignore: avoid_print
        print(
          '[${rec.time} | ${rec.loggerName} | ${rec.level.name}] '
          '${rec.message}',
        );
      },
    );
  }

  /// Log info message.
  void info(String message) => _logger.info(message);

  /// Log fine message.
  void fine(String message) => _logger.fine(message);

  /// Log warning message.
  void warning(String message) => _logger.warning(message);

  /// Log severe message.
  void severe(String message) => _logger.severe(message);
}

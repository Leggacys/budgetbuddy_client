import 'package:logger/logger.dart';

const String devServerUrl = 'http://10.0.2.2:5000';

class MesaLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return !event.message.contains('MESA');
  }
}

final logger = Logger(
  filter: MesaLogFilter(),
);

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

Logger getLogger() {
  return Logger(
    printer: PrettyPrinter(
      lineLength: 90,
      colors: false,
      methodCount: 1,
      errorMethodCount: 5,
      printTime: true,
      printEmojis: false,
    ),
  );
}

void setupLogger() {
  if (kDebugMode) {
    Logger.level = Level.debug;
  } else {
    Logger.level = Level.info;
  }
}

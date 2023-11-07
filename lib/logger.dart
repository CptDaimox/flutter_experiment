import 'package:logger/logger.dart';

const disableStackTrace = false;

final logger = Logger(
    printer:
        PrettyPrinter(methodCount: disableStackTrace ? 0 : 2, lineLength: 50));

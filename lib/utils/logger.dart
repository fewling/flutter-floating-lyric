import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 50,
    excludeBox: {Level.all: true},
    noBoxingByDefault: true,
  ),
  // filter: ProductionFilter(),
);

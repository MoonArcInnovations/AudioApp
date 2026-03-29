import 'package:drift/drift.dart';

QueryExecutor openConnection() {
  // This will be overridden by the mock if needed, or we can put the mock here
  // For now, let's returning a basic mock that we'll define in app_database.dart
  // or we can move the mock here.
  throw UnimplementedError('Web connection should be handled by the mock in app_database.dart or a proper web database.');
}

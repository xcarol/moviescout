import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:moviescout/database/app_database.dart';
import 'package:moviescout/services/core/local_database_service.dart';

void main() {
  group('LocalDatabaseService', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await LocalDatabaseService.close();
      await db.close();
    });

    test('init with custom db sets instance and allows querying', () async {
      await LocalDatabaseService.init(db: db);
      expect(LocalDatabaseService.instance, equals(db));
    });

    test('close clears db instance', () async {
      await LocalDatabaseService.init(db: db);
      expect(LocalDatabaseService.instance, equals(db));

      await LocalDatabaseService.close();
      expect(() => LocalDatabaseService.instance, throwsA(isA<TypeError>()));
    });
  });
}

import 'package:moor/moor.dart';

class Flowers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1)();
  TextColumn get description => text().nullable()();
  BlobColumn get image => blob().nullable()();
}

class Links extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()();
  TextColumn get url => text()();

  IntColumn get flower => integer().customConstraint('REFERENCES flowers(id)')();
}


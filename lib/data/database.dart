import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plants/data/dao.dart';
import 'package:plants/data/tables.dart';
import 'package:path/path.dart' as Path;

part 'database.g.dart';

LazyDatabase _openConnection({String database}) {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(Path.join(dbFolder.path, database ?? 'db.sqlite'));
    return VmDatabase(file, logStatements: true);
  });
}

@UseMoor(tables: [Flowers, Links], daos: [FlowersDao])
class Database extends _$Database {
  Database({ String database }) : super(_openConnection(database: database));

  @override
  // TODO: implement schemaVersion
  int get schemaVersion => 1;

}

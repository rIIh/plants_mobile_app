import 'package:moor/moor.dart';
import 'package:plants/data/database.dart';
import 'package:plants/data/tables.dart';

part 'dao.g.dart';

class FlowerWithLinks {
  Flower flower;
  List<Link> links;

  FlowerWithLinks(this.flower, this.links);
}

class FlowerWithLinksInsertable {
  FlowersCompanion flower;
  List<LinksCompanion> links;

  FlowerWithLinksInsertable({
    this.flower,
    this.links,
  });
}

@UseDao(tables: [Flowers, Links])
class FlowersDao extends DatabaseAccessor<Database> with _$FlowersDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  FlowersDao(Database db) : super(db);

  Stream<List<Flower>> watchFlowers() => select(flowers).watch();

  Stream<List<FlowerWithLinks>> allFlowers() {
    return select(flowers)
        .join([
          leftOuterJoin(
            links,
            links.flower.equalsExp(flowers.id),
          ),
        ])
        .watch()
        .map((rows) {
          final groupedData = <Flower, List<Link>>{};

          for (final row in rows) {
            final flower = row.readTable(flowers);
            final link = row.readTable(links);

            final list = groupedData.putIfAbsent(flower, () => []);
            if (link != null) list.add(link);
          }
          return groupedData.entries.map((e) => FlowerWithLinks(e.key, e.value)).toList();
        });
  }

  Future<int> insertFlower(FlowerWithLinksInsertable flower) async {
    final id = await into(flowers).insert(flower.flower);
    flower.links.map((element) async => await into(links).insert(element.copyWith(flower: Value(id))));
    return id;
  }

  Future<int> createFlower(Insertable<Flower> data) => into(flowers).insert(data);

  void deleteFlowerWithLinks(FlowerWithLinksInsertable flower) {
    deleteFlower(flower.flower);
  }

  Future deleteFlower(FlowersCompanion flower) async {
    await delete(flowers).delete(flower);
    delete(links).where((tbl) => links.flower.equals(flower.id.value));
  }

  void deleteLink(LinksCompanion link) => delete(links).delete(link);

  void updateFlowerWithLinks(FlowerWithLinksInsertable value) async {
    await update(flowers).replace(value.flower);
    print(
      await (delete(links)
            ..where(
              (tbl) => tbl.id.isNotIn(
                value.links.map((e) => e.id.value),
              ),
            )
            ..where(
              (tbl) => tbl.flower.equals(
                value.flower.id.value,
              ),
            ))
          .go(),
    );
    value.links.forEach(
      (element) {
        if (element.id.value == null) {
          into(links).insert(
            element.copyWith(flower: value.flower.id),
          );
        } else {
          update(links).replace(
            element.copyWith(flower: value.flower.id),
          );
        }
      },
    );
  }

  Future<FlowerWithLinks> get(int id) async {
    final rows = (await (select(flowers)
          ..whereSamePrimaryKey(
            FlowersCompanion(id: Value(id)),
          ))
        .join([
      leftOuterJoin(links, links.flower.equalsExp(flowers.id)),
    ]).get());
    final flower = rows.first.readTable(flowers);
    final List<Link> linksData = [];
    rows.forEach((element) => linksData.add(element.readTable(links)));
    return FlowerWithLinks(flower, linksData.where((element) => element != null).toList());
  }

  Stream<Flower> watchFlower(int id) => (select(flowers)
        ..whereSamePrimaryKey(
          FlowersCompanion(
            id: Value(id),
          ),
        ))
      .watchSingle();

  Stream<List<Link>> watchLinks({int flowerKey}) =>
      (select(links)..where((tbl) => links.flower.equals(flowerKey))).watch();

  Stream<FlowerWithLinks> watch(int id) {
    return (select(flowers)
          ..whereSamePrimaryKey(
            FlowersCompanion(id: Value(id)),
          ))
        .join([
          leftOuterJoin(links, links.flower.equalsExp(flowers.id)),
        ])
        .watch()
        .map((rows) {
          final flower = rows.first.readTable(flowers);
          final List<Link> linksData = [];
          rows.forEach((element) => linksData.add(element.readTable(links)));
          return FlowerWithLinks(flower, linksData.where((element) => element != null).toList());
        });
  }

  Future updateFlower(Insertable<Flower> data) => update(flowers).replace(data);

  Future deleteLinks(Iterable<Link> deleted) =>
      (delete(links)..where((tbl) => tbl.id.isIn(deleted.map((e) => e.id).toList()))).go();

  Future updateLinks(Iterable<LinksCompanion> where) =>
      Future.forEach(where, (element) => update(links).replace(element));

  createLink(Insertable<Link> data) => into(links).insert(data);

  Future createLinks(Iterable<LinksCompanion> where) => Future.forEach(where, (element) => into(links).insert(element));
}

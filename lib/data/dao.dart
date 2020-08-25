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

  void deleteFlowerWithLinks(FlowerWithLinksInsertable flower) {
    deleteFlower(flower.flower);
  }

  void deleteFlower(FlowersCompanion flower) {
    delete(flowers).delete(flower);
    delete(links).where((tbl) => links.flower.equals(flower.id.value));
  }

  void deleteLink(LinksCompanion link) => delete(links).delete(link);

  void updateFlowerWithLinks(FlowerWithLinksInsertable value) async {
    await update(flowers).replace(value.flower);
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
}

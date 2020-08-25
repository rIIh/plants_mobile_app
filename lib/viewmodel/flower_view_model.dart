import 'dart:async';

import 'package:moor/moor.dart';
import 'package:plants/data/dao.dart';
import 'package:plants/data/database.dart';
import 'package:plants/types/details_mode.dart';
import 'package:rxdart/rxdart.dart';

class FlowerViewModel {
  final FlowersDao _dao;
  final BehaviorSubject<int> _id = BehaviorSubject();

  void Function() onDelete;
  void Function() onCreated;

  StreamSubscription _flowerSnapshotSubscription;
  Stream<Flower> _flowerSnapshot;

  Stream<Flower> get flowerSnapshot => _flowerSnapshot;
  StreamSubscription _linksSnapshotSubscription;
  Stream<List<Link>> _linksSnapshot;

  Stream<List<Link>> get linksSnapshot => _linksSnapshot;

  Stream<int> get id => _id;

  final BehaviorSubject<FlowersCompanion> _flower = BehaviorSubject.seeded(FlowersCompanion());

  Stream<FlowersCompanion> get flower => _flower;

  final BehaviorSubject<List<LinksCompanion>> _links = BehaviorSubject.seeded([]);

  Stream<List<LinksCompanion>> get links => _links;

  final BehaviorSubject<DetailsMode> _mode = BehaviorSubject();

  Stream<DetailsMode> get mode => _mode;

  final BehaviorSubject<void> _onLoad = BehaviorSubject();

  Stream<void> get onLoad => _onLoad;

  FlowerViewModel(int id, this._dao, {this.onDelete, this.onCreated}) {
    _id.listen((value) {
      _flowerSnapshotSubscription?.cancel();
      _linksSnapshotSubscription?.cancel();
      _flowerSnapshot = _dao.watchFlower(value);
      _linksSnapshot = _dao.watchLinks(flowerKey: value);
      _flowerSnapshotSubscription = _flowerSnapshot.listen((event) {
        _flower.add(event?.toCompanion(true));
        _onLoad.add(null);
      });
      _linksSnapshotSubscription = _linksSnapshot.listen((event) {
        _links.add(event?.map((e) => e.toCompanion(true))?.toList());
        _onLoad.add(null);
      });
    });
    _id.add(id);
    _mode.add(id == null ? DetailsMode.edit : DetailsMode.present);
  }

  bool get isEditMode => _mode.value == DetailsMode.edit;

  bool get isValid =>
      _flower.value?.name?.value?.isNotEmpty == true &&
      _links.value?.every(
            (element) => element.url?.value?.isNotEmpty == true,
          ) ==
          true;

  get isExists => _id.value != null || _flower.value?.id?.value != null;

  void switchMode() {
    final nextMode = DetailsMode.values.firstWhere((element) => element != _mode.value);
    if (nextMode == DetailsMode.present) {
      save();
    }
    _mode.add(nextMode);
  }

  Future _create() async {
    var data = _flower.value;
    final id = await _dao.createFlower(data);
    _id.add(id);
    await Future.forEach<LinksCompanion>(
        _links.value, (element) => _dao.createLink(element.copyWith(flower: Value(id))));
  }

  Future save() async {
    var data = _flower.value;
    if (_id.value == null || !data.id.present) {
      _create();
    } else {
      await _dao.updateFlower(data);
      var deleted = (await _linksSnapshot.first)
          .where((element) => _links.value.any((link) => link.id.value == element.id) == false);
      final remained = _links.value.where((element) => !deleted.contains(element));
      final deletedCount = await _dao.deleteLinks(deleted);
      final insertedCount = await _dao.createLinks(remained.where((element) => !element.id.present));
      final updatedCount = await _dao.updateLinks(remained.where((element) => element.id.present));
      print({
        'name': 'links',
        'deleted': deletedCount,
        'inserted': insertedCount,
        'updated': updatedCount,
      });
    }
  }

  Future delete() => _dao.deleteFlower(FlowersCompanion(id: Value(_id.value))).then((value) => onDelete());

  Value drop(Value value) => value.present ? value : null;

  void edit(FlowersCompanion data) {
    _flower.add((_flower.value ?? FlowersCompanion()).copyWith(
      name: drop(data.name),
      description: drop(data.description),
      image: drop(data.image),
    ));
  }

  void addLink(LinksCompanion link) {
    _links.add([..._links.value, link.copyWith(flower: Value(_id.value))]);
  }

  void removeLink(int index) {
    _links.add([..._links.value]..removeAt(index));
  }

  void editLink(int index, LinksCompanion link) {
    _links.add([
      ..._links.value.sublist(0, index),
      _links.value[index].copyWith(name: drop(link.name), url: drop(link.url)),
      ..._links.value.sublist(index + 1),
    ]);
  }
}

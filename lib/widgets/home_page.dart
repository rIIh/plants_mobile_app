import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:moor/moor.dart' hide Column;
import 'package:plants/data/dao.dart';
import 'package:plants/data/database.dart';
import 'package:plants/widgets/flower_page.dart';

class HomeController extends GetxController {
  final FlowersDao dao;
  final Stream<List<FlowerWithLinks>> watchFlowers;
  StreamSubscription disposer;

  HomeController(this.dao) : watchFlowers = dao.allFlowers();

  Rx<List<FlowerWithLinks>> flowers = Rx();
  var searchQuery = ''.obs;

  void onChange(List<FlowerWithLinks> data) {
    flowers.value = data;
  }

  @override
  void onInit() {
    disposer = watchFlowers.listen(onChange);
  }

  @override
  void onClose() {
    disposer.cancel();
  }

  Future<FlowerWithLinks> get(int id) async => dao.get(id);

  Future<int> save(FlowerWithLinksInsertable value) async => dao.insertFlower(value);

  updateFlower(FlowerWithLinksInsertable value) => dao.updateFlowerWithLinks(value);

  deleteFlower(FlowerWithLinksInsertable value) => dao.deleteFlowerWithLinks(value);
}

class MyHomePage extends GetWidget<HomeController> {
  TextEditingController _searchController;

  MyHomePage() {
    _searchController = TextEditingController(text: controller.searchQuery.value)
      ..addListener(() => controller.searchQuery.value = _searchController.text);
  }

  void openFlowerPage(BuildContext context, FlowerWithLinks flower) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FlowerPage(
          tuple: flower,
          onSubmit: (value) => controller.updateFlower(value),
          onDelete: () async {
            await controller.deleteFlower(
              FlowerWithLinksInsertable(
                flower: FlowersCompanion(
                  id: Value(flower.flower.id),
                ),
              ),
            );
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Widget _buildFlower(FlowerWithLinks flower) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () => openFlowerPage(context, flower),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: flower.flower.image != null
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: MemoryImage(flower.flower.image),
                        )
                      : null,
                ),
                height: 196,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                flower.flower.name,
                style: Theme.of(context).textTheme.headline6,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(22.0).copyWith(top: 0),
                child: Obx(
                  () => Column(
                    children: <Widget>[
                      SizedBox(
                        height: 96,
                      ),
                      if (controller.flowers.value != null)
                        ...(controller.flowers.value
                            .where(
                              (element) => element.flower.name.contains(
                                controller.searchQuery.value,
                              ),
                            )
                            .map(
                              (flower) => [
                                SizedBox(
                                  height: 40,
                                ),
                                _buildFlower(flower)
                              ],
                            )
                            .expand((element) => element)
                            .skip(1)
                            .toList()),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 96,
              padding: EdgeInsets.symmetric(horizontal: 26),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      height: 40,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 16,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 40,
                    width: 40,
                    child: IconButton(
                      icon: Icon(Icons.add),
                      color: Colors.white,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FlowerPage(
                            onSubmit: (value) async {
                              Navigator.of(context).pop();
                              final id = await controller.save(value);
                              final flower = await controller.get(id);
                              openFlowerPage(context, flower);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

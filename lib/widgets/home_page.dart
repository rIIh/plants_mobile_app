import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:moor/moor.dart' hide Column;
import 'package:plants/data/dao.dart';
import 'package:plants/data/database.dart';

import 'flower_view.dart';

class HomeController extends GetxController {
  final FlowersDao dao;

  HomeController(this.dao);

  Rx<List<Flower>> flowers = Rx();
  var searchQuery = ''.obs;

  @override
  void onInit() {
    flowers.bindStream(dao.watchFlowers());
  }
}

class MyHomePage extends GetWidget<HomeController> {
  TextEditingController _searchController;

  MyHomePage() {
    _searchController = TextEditingController(text: '')
      ..addListener(() => controller.searchQuery.value = _searchController.text);
  }

  void openFlowerPage(BuildContext context, Flower flower) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FlowerView(
          flowerKey: flower.id,
        ),
      ),
    );
  }

  Widget _buildFlower(Flower flower) {
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
              child: Hero(
                tag: flower.id,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: flower.image != null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: MemoryImage(flower.image),
                          )
                        : null,
                  ),
                  height: 196,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                flower.name,
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
                              (element) => element.name.toLowerCase().contains(
                                controller.searchQuery.value.toLowerCase(),
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
                          Obx(
                            () => controller.searchQuery.value.isNotEmpty ? GestureDetector(
                              onTap: () => _searchController.text = '',
                              child: Icon(
                                Icons.close,
                                color: Colors.grey,
                              ),
                            ) : Container(),
                          )
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
                      onPressed: () => openFlowerPage(context, null),
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

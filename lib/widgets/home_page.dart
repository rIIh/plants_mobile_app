import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:plants/data/dao.dart';
import 'package:plants/data/database.dart';
import 'package:plants/utils/insert_between.dart';
import 'package:plants/utils/shift_color.dart';

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
  void openFlowerPage(BuildContext context, Flower flower) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FlowerView(
          flowerKey: flower?.id,
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
                borderRadius: BorderRadius.circular(0),
              ),
              child: Hero(
                tag: flower.id,
                child: Container(
                  decoration: BoxDecoration(
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
                style: Theme.of(context).textTheme.headline6.apply(color: Theme.of(context).primaryColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                'фильтр',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .apply(fontWeightDelta: -1, color: shiftColorLuminance(Theme.of(context).primaryColor, 30)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color primary = shiftColorLuminance(Theme.of(context).primaryColorDark, 0);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Book'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        textTheme: Theme.of(context).primaryTextTheme.apply(
              bodyColor: primary,
            ),
        iconTheme: IconThemeData(color: primary),
        bottom: Toolbar(
          color: primary,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => openFlowerPage(context, null),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Obx(
              () => Column(
                children: insertBetween(
                  Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Divider(
                        height: 1,
                        thickness: 1.2,
                        color: primary,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  [
                    if (controller.flowers.value != null)
                      ...(controller.flowers.value
                          .where(
                            (element) => element.name.toLowerCase().contains(
                                  controller.searchQuery.value.toLowerCase(),
                                ),
                          )
                          .map(
                            (flower) => [
                              _buildFlower(flower),
                            ],
                          )
                          .expand((element) => element)
                          .toList()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Toolbar extends GetWidget<HomeController> implements PreferredSizeWidget {
  final Color color;
  TextEditingController _searchController;

  Toolbar({Key key, this.color}) : super(key: key) {
    _searchController = TextEditingController(text: '')
      ..addListener(() => controller.searchQuery.value = _searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      width: preferredSize.width,
      child: Container(
        decoration: BoxDecoration(
          border: Border.symmetric(
            vertical: BorderSide(color: color),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            border: InputBorder.none,
                            fillColor: color,
                            hintText: 'Поиск',
                            icon: Icon(
                              Icons.search,
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => controller.searchQuery.value.isNotEmpty
                            ? GestureDetector(
                                onTap:
                                    controller.searchQuery.value.isNotEmpty ? () => _searchController.text = '' : null,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.grey,
                                ),
                              )
                            : Container(),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: color,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: insertBetween(
                          VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: color,
                          ),
                          [
                            ...List.generate(
                              10,
                              (index) => Container(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Center(
                                  child: Text(
                                    'Фильтр',
                                    style: TextStyle(color: color),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: color,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.tune,
                      color: color,
                    ),
                    onPressed: null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight * 2);
}

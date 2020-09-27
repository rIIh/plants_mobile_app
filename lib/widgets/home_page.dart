import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:plants/data/dao.dart';
import 'package:plants/data/database.dart';
import 'package:plants/icons/plants_icons.dart';
import 'package:plants/utils/insert_between.dart';
import 'package:plants/utils/shift_color.dart';
import 'package:plants/views/flowers_grid/view.dart';
import 'package:plants/widgets/app_bar.dart';
import 'package:plants/widgets/inherited_icon_button.dart';
import 'package:plants/widgets/main_app_bar.dart';

import 'bottom_navigation_bar_item.dart';
import 'flower_view.dart';
import 'search_app_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    const padding = 12.0;

    return Scaffold(
      appBar: HomeAppBar(
        title: Text('My Book'),
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: IconTheme(
            data: IconThemeData(size: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Plants.home),
                Icon(Plants.plant),
                GestureDetector(
                  onTap: () => openFlowerPage(context, null),
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      shape: CircleBorder(),
                      color: Colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Icon(Plants.plant),
                Icon(Plants.user),
              ],
            ),
          ),
        ),
      ),
      body: FlowersGridView(
        padding: const EdgeInsets.all(padding),
      ),
    );
  }
}

class Toolbar extends GetWidget<HomeController> implements PreferredSizeWidget {
  final Color color;
  final double padding;
  final bool hideFilters;
  final double height;
  TextEditingController _searchController;

  Toolbar({
    Key key,
    this.padding = 20,
    this.color,
    this.hideFilters = true,
    this.height = kToolbarHeight,
  }) : super(key: key) {
    _searchController = TextEditingController(text: '')
      ..addListener(() => controller.searchQuery.value = _searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      width: preferredSize.width,
      margin: EdgeInsets.symmetric(horizontal: padding),
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
                          style: TextStyle(color: color),
                          decoration: InputDecoration(
                            isCollapsed: true,
                            border: InputBorder.none,
                            fillColor: color,
                            hintText: 'Поиск',
                            hintStyle: TextStyle(color: shiftColorLuminance(color, 50)),
                            icon: Icon(
                              Icons.search,
                              color: color,
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
                                  color: color,
                                ),
                              )
                            : Container(),
                      )
                    ],
                  ),
                ),
              ),
            ),
            if (!hideFilters) ...[
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
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height * (hideFilters ? 1 : 2));
}

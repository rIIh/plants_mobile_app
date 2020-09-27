
import 'package:get/get.dart';
import 'package:plants/data/dao.dart';
import 'package:plants/data/database.dart';
import 'package:plants/views/flowers_grid/cubit.dart';
import 'package:plants/widgets/home_page.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    final db = Database();
    final dao = FlowersDao(db);
    Get.put(db);
    Get.put(dao);
    Get.put(HomeController(dao));
    Get.put(FlowersGridCubit());
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:plants/binding/app_binding.dart';
import 'package:plants/color.dart';
import 'widgets/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(FocusScope.of(context).hasPrimaryFocus);
        var unfocus = new FocusNode();
        FocusScope.of(context)..requestFocus(unfocus);
        unfocus..unfocus()..dispose();
      },
      child: GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryColor: Colors.black,
          fontFamily: 'Playfair',
        ),
        initialBinding: AppBinding(),
        home: MyHomePage(),
      ),
    );
  }
}





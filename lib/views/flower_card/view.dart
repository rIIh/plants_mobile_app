import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plants/data/database.dart';
import 'package:plants/widgets/flower_view.dart';

class FlowerCard extends StatelessWidget {
  final Flower flower;

  const FlowerCard({Key key, @required this.flower}) : super(key: key);

  void openFlowerPage() {
    Get.to(
      FlowerView(
        flowerKey: flower?.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openFlowerPage,
      child: Card(
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: flower.id,
              child: Container(
                decoration: BoxDecoration(
                  image: flower.image != null
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: MemoryImage(flower.image),
                        )
                      : null,
                  color: Colors.grey.shade300,
                ),
                height: 124,
              ),
            ),
            const SizedBox(height: 8.0,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                flower.name,
                style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'tag',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            const SizedBox(height: 8.0,),
          ],
        ),
      ),
    );
  }
}

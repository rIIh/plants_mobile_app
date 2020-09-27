import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:plants/views/flower_card/view.dart';
import 'package:plants/views/flowers_grid/cubit.dart';
import 'package:plants/views/flowers_grid/state.dart';

class FlowersGridView extends StatefulWidget {
  final EdgeInsets padding;

  const FlowersGridView({Key key, this.padding}) : super(key: key);

  @override
  _FlowersGridViewState createState() => _FlowersGridViewState();
}

class _FlowersGridViewState extends State<FlowersGridView> {
  FlowersGridCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlowersGridCubit, FlowersGridState>(
      cubit: cubit,
      builder: (context, state) => state.map(
        loading: (value) => Center(child: CircularProgressIndicator()),
        hasData: (value) => GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          padding: widget.padding,
          itemCount: value.flowers.length,
          itemBuilder: (context, index) => FlowerCard(
            flower: value.flowers[index],
          ),
        ),
      ),
    );
  }
}

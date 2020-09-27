import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:plants/utils/dispose_bag.dart';

abstract class DisposableCubit<T> extends Cubit<T> implements Disposable {
  DisposableCubit(T state) : super(state);

  @override
  void dispose() {}
}

abstract class DisposableState<T extends StatefulWidget> extends State<T> implements Disposable {
  @override
  void dispose() {}
}

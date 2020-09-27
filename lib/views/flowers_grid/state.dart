
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:plants/data/database.dart';

part 'state.freezed.dart';

@freezed
abstract class FlowersGridState with _$FlowersGridState {
  const factory FlowersGridState.loading() = _Loading;
  const factory FlowersGridState.hasData(List<Flower> flowers) = _HasData;
}
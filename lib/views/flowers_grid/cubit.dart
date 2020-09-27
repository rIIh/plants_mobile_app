import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:plants/data/dao.dart';
import 'package:plants/data/database.dart';
import 'package:plants/utils/disposable_cubit.dart';
import 'package:plants/utils/dispose_bag.dart';
import 'package:plants/utils/reactive.dart';

import 'state.dart';

class FlowersGridCubit extends DisposableCubit<FlowersGridState> with DisposeBagMixin {
  final FlowersDao _dao;

  final Reactive<String> _query = Reactive('');

  ReadOnlyReactive<String> get query => _query;

  FlowersGridCubit([FlowersDao dao])
      : _dao = dao ?? Get.find(),
        super(FlowersGridState.loading()) {
    fetchFlowers();
    _dao.watchFlowers().skip(1).listen(
      (event) {
        emit(
          FlowersGridState.hasData(
            _filter(event),
          ),
        );
      },
    ).disposedBy(this);
    _query
        .watch()
        .distinct()
        .listen(
          (event) => fetchFlowers(),
        )
        .disposedBy(this);
  }

  List<Flower> _filter(List<Flower> flowers) => flowers
      .where(
        (element) => element.name.toLowerCase().contains(
              query.value.toLowerCase(),
            ),
      )
      .toList();

  Future<List<Flower>> fetchFlowers() async {
    final result = _filter(
      await _dao.getFlowers(),
    );
    emit(
      FlowersGridState.hasData(result),
    );
    return result;
  }
}

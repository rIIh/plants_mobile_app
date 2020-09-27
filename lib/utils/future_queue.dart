import 'dart:async';

import 'tuple.dart';

typedef FutureBuilder<T> = Future<T> Function();

class FutureQueue<T> {
  final List<Tuple2<FutureBuilder<T>, Completer<T>>> _queue;

  FutureQueue() : _queue = [];

  Future<T> enqueue(FutureBuilder<T> builder) {
    final resolver = Completer<T>();
    _queue.add(Tuple2(builder, resolver));
    if (_queue.length == 1) {
      next();
    }
    return resolver.future;
  }

  void next() {
    if (_queue.length > 0) {
      final tuple = _queue[0];
      final builder = tuple.a;
      final completer = tuple.b;
      builder().then((result) {
        completer.complete(result);
        _queue.removeAt(0);
        next();
      });
    }
  }
}

import 'dart:async';

// ignore: one_member_abstracts
abstract class Disposable {
  void dispose() {}
}

class DisposeBag implements Disposable {
  final List<Disposable> _disposables;
  final List<StreamSubscription> _cancellables;

  DisposeBag([List<Disposable> disposables, List<StreamSubscription> cancellables])
      : _disposables = disposables ?? [],
        _cancellables = cancellables ?? [];

  void addDisposable(Disposable disposable) => _disposables.add(disposable);

  void addSubscription(StreamSubscription disposable) => _cancellables.add(disposable);

  @override
  void dispose() {
    for (var disposable in _disposables) {
      disposable.dispose();
    }
    for (var cancellable in _cancellables) {
      cancellable.cancel();
    }
  }
}

mixin DisposeBagMixin on Disposable implements DisposeBag {
  final List<Disposable> _disposables = [];
  final List<StreamSubscription> _cancellables = [];

  void addDisposable(Disposable disposable) => _disposables.add(disposable);

  void addSubscription(StreamSubscription disposable) => _cancellables.add(disposable);

  @override
  void dispose() {
    super.dispose();
    for (var disposable in _disposables) {
      disposable.dispose();
    }
    for (var cancellable in _cancellables) {
      cancellable.cancel();
    }
    print('[DisposeBagMixin.dispose]: Disposed');
  }
}

extension CancelledByExtension on StreamSubscription {
  void disposedBy(DisposeBag _bag) {
    _bag.addSubscription(this);
  }
}

extension DisposedByExtension on Disposable {
  void disposedBy(DisposeBag _bag) {
    _bag.addDisposable(this);
  }
}

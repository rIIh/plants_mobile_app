// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$FlowersGridStateTearOff {
  const _$FlowersGridStateTearOff();

// ignore: unused_element
  _Loading loading() {
    return const _Loading();
  }

// ignore: unused_element
  _HasData hasData(List<Flower> flowers) {
    return _HasData(
      flowers,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $FlowersGridState = _$FlowersGridStateTearOff();

/// @nodoc
mixin _$FlowersGridState {
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result loading(),
    @required Result hasData(List<Flower> flowers),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result loading(),
    Result hasData(List<Flower> flowers),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result loading(_Loading value),
    @required Result hasData(_HasData value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result loading(_Loading value),
    Result hasData(_HasData value),
    @required Result orElse(),
  });
}

/// @nodoc
abstract class $FlowersGridStateCopyWith<$Res> {
  factory $FlowersGridStateCopyWith(
          FlowersGridState value, $Res Function(FlowersGridState) then) =
      _$FlowersGridStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$FlowersGridStateCopyWithImpl<$Res>
    implements $FlowersGridStateCopyWith<$Res> {
  _$FlowersGridStateCopyWithImpl(this._value, this._then);

  final FlowersGridState _value;
  // ignore: unused_field
  final $Res Function(FlowersGridState) _then;
}

/// @nodoc
abstract class _$LoadingCopyWith<$Res> {
  factory _$LoadingCopyWith(_Loading value, $Res Function(_Loading) then) =
      __$LoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$LoadingCopyWithImpl<$Res> extends _$FlowersGridStateCopyWithImpl<$Res>
    implements _$LoadingCopyWith<$Res> {
  __$LoadingCopyWithImpl(_Loading _value, $Res Function(_Loading) _then)
      : super(_value, (v) => _then(v as _Loading));

  @override
  _Loading get _value => super._value as _Loading;
}

/// @nodoc
class _$_Loading implements _Loading {
  const _$_Loading();

  @override
  String toString() {
    return 'FlowersGridState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _Loading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result loading(),
    @required Result hasData(List<Flower> flowers),
  }) {
    assert(loading != null);
    assert(hasData != null);
    return loading();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result loading(),
    Result hasData(List<Flower> flowers),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result loading(_Loading value),
    @required Result hasData(_HasData value),
  }) {
    assert(loading != null);
    assert(hasData != null);
    return loading(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result loading(_Loading value),
    Result hasData(_HasData value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements FlowersGridState {
  const factory _Loading() = _$_Loading;
}

/// @nodoc
abstract class _$HasDataCopyWith<$Res> {
  factory _$HasDataCopyWith(_HasData value, $Res Function(_HasData) then) =
      __$HasDataCopyWithImpl<$Res>;
  $Res call({List<Flower> flowers});
}

/// @nodoc
class __$HasDataCopyWithImpl<$Res> extends _$FlowersGridStateCopyWithImpl<$Res>
    implements _$HasDataCopyWith<$Res> {
  __$HasDataCopyWithImpl(_HasData _value, $Res Function(_HasData) _then)
      : super(_value, (v) => _then(v as _HasData));

  @override
  _HasData get _value => super._value as _HasData;

  @override
  $Res call({
    Object flowers = freezed,
  }) {
    return _then(_HasData(
      flowers == freezed ? _value.flowers : flowers as List<Flower>,
    ));
  }
}

/// @nodoc
class _$_HasData implements _HasData {
  const _$_HasData(this.flowers) : assert(flowers != null);

  @override
  final List<Flower> flowers;

  @override
  String toString() {
    return 'FlowersGridState.hasData(flowers: $flowers)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _HasData &&
            (identical(other.flowers, flowers) ||
                const DeepCollectionEquality().equals(other.flowers, flowers)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(flowers);

  @override
  _$HasDataCopyWith<_HasData> get copyWith =>
      __$HasDataCopyWithImpl<_HasData>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result loading(),
    @required Result hasData(List<Flower> flowers),
  }) {
    assert(loading != null);
    assert(hasData != null);
    return hasData(flowers);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result loading(),
    Result hasData(List<Flower> flowers),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (hasData != null) {
      return hasData(flowers);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result loading(_Loading value),
    @required Result hasData(_HasData value),
  }) {
    assert(loading != null);
    assert(hasData != null);
    return hasData(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result loading(_Loading value),
    Result hasData(_HasData value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (hasData != null) {
      return hasData(this);
    }
    return orElse();
  }
}

abstract class _HasData implements FlowersGridState {
  const factory _HasData(List<Flower> flowers) = _$_HasData;

  List<Flower> get flowers;
  _$HasDataCopyWith<_HasData> get copyWith;
}

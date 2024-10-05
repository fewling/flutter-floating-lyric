part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(null) MediaState? mediaState,
  }) = _HomeState;
}

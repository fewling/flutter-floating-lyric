part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(null) MediaState? mediaState,
    @Default(false) bool isWindowVisible,
    @Default(false) bool isWindowLocked,
    @Default(false) bool isWindowTouchThrough,
    @Default(false) bool isWIndowIgnoreTouch,
    @Default(false) bool isSearchingOnline,
    @Default(null) String? titleAlt,
    @Default(null) String? artistAlt,
    @Default(null) String? albumAlt,
    @Default(false) bool isEditingTitle,
    @Default(false) bool isEditingArtist,
    @Default(false) bool isEditingAlbum,
    @Default(null) LrcLibResponse? lrcLibResponse,
  }) = _HomeState;
}

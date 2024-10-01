part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(0) int currentIndex,
    @Default(null) MediaState? mediaState,
    @Default(false) bool isWindowVisible,
    @Default(false) bool isWindowLocked,
    @Default(false) bool isWindowTouchThrough,
    @Default(false) bool isWIndowIgnoreTouch,
    @Default(false) bool isProcessingFiles,
    @Default(false) bool isSearchingOnline,
    @Default(null) String? titleAlt,
    @Default(null) String? artistAlt,
    @Default(null) String? albumAlt,
    @Default(false) bool isEditingTitle,
    @Default(false) bool isEditingArtist,
    @Default(false) bool isEditingAlbum,
    @Default(<PlatformFile>[]) List<PlatformFile> failedFiles,
    @Default(null) LrcLibResponse? lrcLibResponse,
  }) = _HomeState;
}

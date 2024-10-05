part of 'fetch_online_lrc_form_bloc.dart';

@freezed
class FetchOnlineLrcFormState with _$FetchOnlineLrcFormState {
  const factory FetchOnlineLrcFormState({
    String? title,
    String? artist,
    String? album,
    String? titleAlt,
    String? artistAlt,
    String? albumAlt,
    double? duration,
    @Default(false) bool isSearchingOnline,
    @Default(false) bool isEditingTitle,
    @Default(false) bool isEditingArtist,
    @Default(false) bool isEditingAlbum,
    @Default(null) LrcLibResponse? lrcLibResponse,
  }) = _FetchOnlineLrcFormState;
}

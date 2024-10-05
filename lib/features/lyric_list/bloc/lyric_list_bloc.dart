import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/lyric_model.dart';
import '../../../service/db/local/local_db_service.dart';
import '../../../service/lrc/lrc_process_service.dart';

part 'lyric_list_bloc.freezed.dart';
part 'lyric_list_event.dart';
part 'lyric_list_state.dart';

class LyricListBloc extends Bloc<LyricListEvent, LyricListState> {
  LyricListBloc({
    required LocalDbService localDbService,
    required LrcProcessorService lrcProcessorService,
  })  : _localDbService = localDbService,
        _lrcProcessorService = lrcProcessorService,
        super(const LyricListState()) {
    on<LyricListEvent>(
      (event, emit) => switch (event) {
        LyricListLoaded() => _onLyricListLoaded(event, emit),
        SearchUpdated() => _onSearchUpdated(event, emit),
        DeleteRequested() => _onDeleteRequested(event, emit),
        DeleteAllRequested() => _onDeleteAllRequested(event, emit),
        ImportLRCsRequested() => _onImportLRCsRequested(event, emit),
      },
    );
  }

  final LrcProcessorService _lrcProcessorService;
  final LocalDbService _localDbService;

  Future<void> _onLyricListLoaded(LyricListLoaded event, Emitter<LyricListState> emit) async {
    final lyrics = await _localDbService.getAllLyrics();
    emit(state.copyWith(lyrics: lyrics));
  }

  Future<void> _onSearchUpdated(SearchUpdated event, Emitter<LyricListState> emit) async {
    if (event.searchTerm.isEmpty) {
      add(const LyricListLoaded());
      return;
    }

    final lyrics = await _localDbService.searchLyrics(event.searchTerm);
    emit(state.copyWith(lyrics: lyrics));
  }

  Future<void> _onDeleteRequested(DeleteRequested event, Emitter<LyricListState> emit) async {
    await _localDbService.deleteLrc(event.lyric);

    final lyrics = state.lyrics.where((l) => l.id != event.lyric.id).toList();
    emit(state.copyWith(lyrics: lyrics));
  }

  Future<void> _onDeleteAllRequested(DeleteAllRequested event, Emitter<LyricListState> emit) async {
    try {
      await _localDbService.deleteAllLyrics();
      emit(state.copyWith(
        lyrics: [],
        deleteStatus: LyricListDeleteStatus.deleted,
      ));
    } catch (e) {
      emit(state.copyWith(
        deleteStatus: LyricListDeleteStatus.error,
      ));
    }
  }

  Future<void> _onImportLRCsRequested(ImportLRCsRequested event, Emitter<LyricListState> emit) async {
    try {
      emit(state.copyWith(
        importStatus: LyricListImportStatus.importing,
      ));

      final failed = await _lrcProcessorService.pickLrcFiles();

      emit(state.copyWith(
        failedImportFiles: failed,
        importStatus: failed.isEmpty ? LyricListImportStatus.initial : LyricListImportStatus.error,
      ));
    } catch (e) {
      emit(state.copyWith(
        importStatus: LyricListImportStatus.error,
        failedImportFiles: [],
      ));
    } finally {
      add(const LyricListLoaded());
    }
  }
}

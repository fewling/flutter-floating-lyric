import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/lyric_model.dart';
import '../../services/db/local/local_db_service.dart';
import '../../services/lrc/lrc_process_service.dart';

part 'lyric_list_bloc.freezed.dart';
part 'lyric_list_event.dart';
part 'lyric_list_state.dart';

class LyricListBloc extends Bloc<LyricListEvent, LyricListState> {
  LyricListBloc({
    required LocalDbService localDbService,
    required LrcProcessorService lrcProcessorService,
  }) : _localDbService = localDbService,
       _lrcProcessorService = lrcProcessorService,
       super(const LyricListState()) {
    on<LyricListEvent>(
      (event, emit) => switch (event) {
        _Started() => _onStarted(event, emit),
        _SearchUpdated() => _onSearchUpdated(event, emit),
        _DeleteRequested() => _onDeleteRequested(event, emit),
        _DeleteAllRequested() => _onDeleteAllRequested(event, emit),
        _ImportLRCsRequested() => _onImportLRCsRequested(event, emit),
        _DeleteStatusHandled() => _onDeleteStatusHandled(event, emit),
      },
    );
  }

  final LrcProcessorService _lrcProcessorService;
  final LocalDbService _localDbService;

  Future<void> _onStarted(_Started event, Emitter<LyricListState> emit) async {
    final lyrics = await _localDbService.getAllLyrics();
    emit(state.copyWith(lyrics: lyrics));

    await emit.onEach(
      _localDbService.watch(),
      onData: (data) async {
        emit(
          state.copyWith(
            lyrics: state.searchTerm.isEmpty
                ? await _localDbService.getAllLyrics()
                : await _localDbService.searchLyrics(state.searchTerm),
          ),
        );
      },
    );
  }

  Future<void> _onSearchUpdated(
    _SearchUpdated event,
    Emitter<LyricListState> emit,
  ) async {
    final lyrics = event.searchTerm.isEmpty
        ? await _localDbService.getAllLyrics()
        : await _localDbService.searchLyrics(event.searchTerm);
    emit(state.copyWith(lyrics: lyrics, searchTerm: event.searchTerm));
  }

  Future<void> _onDeleteRequested(
    _DeleteRequested event,
    Emitter<LyricListState> emit,
  ) async {
    try {
      await _localDbService.deleteLrc(event.lyric);

      final lyrics = state.lyrics.where((l) => l.id != event.lyric.id).toList();
      emit(
        state.copyWith(
          lyrics: lyrics,
          deleteStatus: LyricListDeleteStatus.deleted,
        ),
      );
    } catch (e) {
      emit(state.copyWith(deleteStatus: LyricListDeleteStatus.error));
    }
  }

  Future<void> _onDeleteAllRequested(
    _DeleteAllRequested event,
    Emitter<LyricListState> emit,
  ) async {
    try {
      await _localDbService.deleteAllLyrics();
      emit(
        state.copyWith(lyrics: [], deleteStatus: LyricListDeleteStatus.deleted),
      );
    } catch (e) {
      emit(state.copyWith(deleteStatus: LyricListDeleteStatus.error));
    }
  }

  Future<void> _onImportLRCsRequested(
    _ImportLRCsRequested event,
    Emitter<LyricListState> emit,
  ) async {
    try {
      emit(state.copyWith(importStatus: LyricListImportStatus.importing));

      final (success, failed) = await _lrcProcessorService.pickLrcFiles();

      await _localDbService.saveBatchLrc(success);

      emit(
        state.copyWith(
          failedImportFiles: failed,
          importStatus: failed.isEmpty
              ? LyricListImportStatus.initial
              : LyricListImportStatus.error,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          importStatus: LyricListImportStatus.error,
          failedImportFiles: [],
        ),
      );
    }
  }

  void _onDeleteStatusHandled(
    _DeleteStatusHandled event,
    Emitter<LyricListState> emit,
  ) {
    emit(state.copyWith(deleteStatus: LyricListDeleteStatus.initial));
  }
}

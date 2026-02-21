import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/lyric_model.dart';
import '../../repos/lrclib/lrclib_repository.dart';
import '../../services/db/local/local_db_service.dart';
import '../../utils/logger.dart';

part 'save_lrc_bloc.freezed.dart';
part 'save_lrc_event.dart';
part 'save_lrc_state.dart';

class SaveLrcBloc extends Bloc<SaveLrcEvent, SaveLrcState> {
  SaveLrcBloc({required LocalDbService localDbService})
    : _localDbService = localDbService,
      super(const SaveLrcState()) {
    on<SaveLrcEvent>(
      (event, emit) => switch (event) {
        _SaveOnlineLrcResponse() => _onSaveOnlineLrcResponse(event, emit),
        _SaveLocalLrc() => _onSaveLocalLrc(event, emit),
      },
    );
  }

  final LocalDbService _localDbService;

  Future<void> _onSaveOnlineLrcResponse(
    _SaveOnlineLrcResponse event,
    Emitter<SaveLrcState> emit,
  ) async {
    emit(
      state.copyWith(saveLrcStatus: SaveLrcStatus.loading, lastSavedLrcs: []),
    );

    try {
      final response = event.lrcLibResponse;
      final id = await _localDbService.saveLrc(
        title: response.trackName,
        artist: response.artistName,
        content: response.syncedLyrics,
      );

      final savedLrc = await _localDbService.getLyricById(id);

      emit(
        state.copyWith(
          saveLrcStatus: SaveLrcStatus.success,
          lastSavedLrcs: [savedLrc].nonNulls.toList(),
        ),
      );
    } catch (e) {
      logger.e('Failed to save lyric to local DB', error: e);
      emit(
        state.copyWith(saveLrcStatus: SaveLrcStatus.failure, lastSavedLrcs: []),
      );
    }
  }

  void _onSaveLocalLrc(_SaveLocalLrc event, Emitter<SaveLrcState> emit) {}
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/lyric_model.dart';
import '../../services/db/local/local_db_service.dart';

part 'lyric_detail_bloc.freezed.dart';
part 'lyric_detail_event.dart';
part 'lyric_detail_state.dart';

class LyricDetailBloc extends Bloc<LyricDetailEvent, LyricDetailState> {
  LyricDetailBloc({required LocalDbService localDbService})
    : _localDbService = localDbService,
      super(const LyricDetailState()) {
    on<LyricDetailEvent>(
      (event, emit) => switch (event) {
        _Started() => _onLoaded(event, emit),
        _SaveRequested() => _onSaveRequested(event, emit),
        _ContentUpdated() => _onContentUpdated(event, emit),
        _SaveStatusReset() => _onSaveStatusReset(event, emit),
      },
    );
  }

  final LocalDbService _localDbService;

  Future<void> _onLoaded(_Started event, Emitter<LyricDetailState> emit) async {
    final lrc = _localDbService.getLyricById(event.id);
    emit(state.copyWith(lrcModel: lrc, originalContent: lrc?.content ?? ''));
  }

  Future<void> _onSaveRequested(
    _SaveRequested event,
    Emitter<LyricDetailState> emit,
  ) async {
    if (state.lrcModel == null) return;

    try {
      await _localDbService.updateLrc(state.lrcModel!);

      emit(
        state.copyWith(
          originalContent: state.lrcModel!.content ?? '',
          saveStatus: LyricSaveStatus.saved,
        ),
      );
    } catch (e) {
      emit(state.copyWith(saveStatus: LyricSaveStatus.error));
    }
  }

  void _onContentUpdated(
    _ContentUpdated event,
    Emitter<LyricDetailState> emit,
  ) {
    if (state.lrcModel == null) return;

    final newLrc = state.lrcModel!.copyWith(content: event.content);
    emit(state.copyWith(lrcModel: newLrc));
  }

  void _onSaveStatusReset(
    _SaveStatusReset event,
    Emitter<LyricDetailState> emit,
  ) => emit(state.copyWith(saveStatus: LyricSaveStatus.initial));
}

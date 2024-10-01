import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/lyric_model.dart';
import '../../../../service/db/local/local_db_service.dart';

part 'lyric_detail_bloc.freezed.dart';
part 'lyric_detail_event.dart';
part 'lyric_detail_state.dart';

class LyricDetailBloc extends Bloc<LyricDetailEvent, LyricDetailState> {
  LyricDetailBloc({
    required LocalDbService localDbService,
  })  : _localDbService = localDbService,
        super(const LyricDetailState()) {
    on<LyricDetailEvent>(
      (event, emit) => switch (event) {
        LyricDetailLoaded() => _onLoaded(event, emit),
        SaveRequested() => _onSaveRequested(event, emit),
        ContentUpdated() => _onContentUpdated(event, emit),
        SaveStatusReset() => _onSaveStatusReset(event, emit),
      },
    );
  }

  final LocalDbService _localDbService;

  Future<void> _onLoaded(LyricDetailLoaded event, Emitter<LyricDetailState> emit) async {
    if (event.id == null) return;

    final lrc = await _localDbService.getLyric(event.id!);
    emit(state.copyWith(
      lrcDB: lrc,
      originalContent: lrc?.content ?? '',
    ));
  }

  Future<void> _onSaveRequested(SaveRequested event, Emitter<LyricDetailState> emit) async {
    if (state.lrcDB == null) return;

    await _localDbService.updateLrc(state.lrcDB!);

    emit(state.copyWith(originalContent: state.lrcDB!.content ?? ''));
  }

  void _onContentUpdated(ContentUpdated event, Emitter<LyricDetailState> emit) {
    if (state.lrcDB == null) return;

    final newLrc = state.lrcDB!..content = event.content;
    emit(state.copyWith(lrcDB: newLrc));
  }

  void _onSaveStatusReset(SaveStatusReset event, Emitter<LyricDetailState> emit) {
    emit(state.copyWith(saveStatus: LyricSaveStatus.initial));
  }
}

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/lyric_model.dart';
import '../../services/lrc/lrc_process_service.dart';

part 'local_lrc_picker_bloc.freezed.dart';
part 'local_lrc_picker_event.dart';
part 'local_lrc_picker_state.dart';

class LocalLrcPickerBloc
    extends Bloc<LocalLrcPickerEvent, LocalLrcPickerState> {
  LocalLrcPickerBloc({required LrcProcessorService lrcProcessorService})
    : _lrcProcessorService = lrcProcessorService,
      super(const LocalLrcPickerState()) {
    on<LocalLrcPickerEvent>(
      (event, emit) => switch (event) {
        _ImportLRCsRequested() => _onImportLRCsRequested(event, emit),
      },
    );
  }

  final LrcProcessorService _lrcProcessorService;

  Future<void> _onImportLRCsRequested(
    _ImportLRCsRequested event,
    Emitter<LocalLrcPickerState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ImportLocalLrcStatus.loading,
        failedFiles: [],
        availableLrcs: [],
      ),
    );
    try {
      final (success, failed) = await _lrcProcessorService.pickLrcFiles();

      emit(
        state.copyWith(
          status: failed.isEmpty
              ? ImportLocalLrcStatus.success
              : ImportLocalLrcStatus.failed,
          availableLrcs: success,
          failedFiles: failed,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ImportLocalLrcStatus.failed,
          failedFiles: [],
          availableLrcs: [],
        ),
      );
    }
  }
}

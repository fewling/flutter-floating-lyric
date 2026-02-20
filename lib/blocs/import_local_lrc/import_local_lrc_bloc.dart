import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../services/lrc/lrc_process_service.dart';

part 'import_local_lrc_bloc.freezed.dart';
part 'import_local_lrc_event.dart';
part 'import_local_lrc_state.dart';

class ImportLocalLrcBloc
    extends Bloc<ImportLocalLrcEvent, ImportLocalLrcState> {
  ImportLocalLrcBloc({required LrcProcessorService lrcProcessorService})
    : _lrcProcessorService = lrcProcessorService,
      super(const ImportLocalLrcState()) {
    on<ImportLocalLrcEvent>(
      (event, emit) => switch (event) {
        _Started() => _onStarted(event, emit),
        _ImportLRCsRequested() => _onImportLRCsRequested(event, emit),
        _ImportStatusHandled() => _onImportStatusHandled(event, emit),
      },
    );
  }

  final LrcProcessorService _lrcProcessorService;

  void _onStarted(_Started event, Emitter<ImportLocalLrcState> emit) {}

  Future<void> _onImportLRCsRequested(
    _ImportLRCsRequested event,
    Emitter<ImportLocalLrcState> emit,
  ) async {
    emit(state.copyWith(status: ImportLocalLrcStatus.processingFiles));
    try {
      final failed = await _lrcProcessorService.pickLrcFiles();

      emit(
        state.copyWith(
          status: failed.isEmpty
              ? ImportLocalLrcStatus.success
              : ImportLocalLrcStatus.failed,
          failedFiles: failed,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ImportLocalLrcStatus.failed, failedFiles: []),
      );
    }
  }

  void _onImportStatusHandled(
    _ImportStatusHandled event,
    Emitter<ImportLocalLrcState> emit,
  ) {
    emit(state.copyWith(status: ImportLocalLrcStatus.initial, failedFiles: []));
  }
}

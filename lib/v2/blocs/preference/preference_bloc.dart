import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../configs/animation_modes.dart';
import '../../../repos/local/preference_repo.dart';
import '../../enums/app_locale.dart';

part 'preference_bloc.freezed.dart';
part 'preference_event.dart';
part 'preference_state.dart';

class PreferenceBloc extends Bloc<PreferenceEvent, PreferenceState> {
  PreferenceBloc({required PreferenceRepo preferenceRepo})
    : _preferenceRepo = preferenceRepo,
      super(
        PreferenceState(
          opacity: preferenceRepo.opacity,
          color: preferenceRepo.color,
          backgroundColor: preferenceRepo.backgroundColor,
          isLight: preferenceRepo.isLight,
          appColorScheme: preferenceRepo.appColorScheme,
          showMilliseconds: preferenceRepo.showMilliseconds,
          showProgressBar: preferenceRepo.showProgressBar,
          fontFamily: preferenceRepo.fontFamily,
          fontSize: preferenceRepo.fontSize,
          autoFetchOnline: preferenceRepo.autoFetchOnline,
          showLine2: preferenceRepo.showLine2,
          useAppColor: preferenceRepo.useAppColor,
          enableAnimation: preferenceRepo.enableAnimation,
          tolerance: preferenceRepo.tolerance,
          animationMode: preferenceRepo.animationMode,
          transparentNotFoundTxt: preferenceRepo.transparentNotFoundTxt,
          locale: preferenceRepo.locale,
        ),
      ) {
    on<PreferenceEvent>(
      (event, emit) => switch (event) {
        _Started() => _onStarted(event, emit),
        _LocaleUpdated() => _onLocaleUpdated(event, emit),
      },
    );
  }

  final PreferenceRepo _preferenceRepo;

  void _onStarted(_Started event, Emitter<PreferenceState> emit) {}

  Future<void> _onLocaleUpdated(
    _LocaleUpdated event,
    Emitter<PreferenceState> emit,
  ) async {
    final isSuccess = await _preferenceRepo.updateLocale(event.locale);
    if (isSuccess) {
      emit(state.copyWith(locale: event.locale));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../configs/animation_modes.dart';
import '../../enums/app_locale.dart';
import '../../repos/persistence/local/preference_repo.dart';

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
        _WindowColorThemeToggled() => _onWindowColorThemeToggled(event, emit),
        _BackgroundColorUpdated() => _onBackgroundColorUpdated(event, emit),
        _OpacityUpdated() => _onOpacityUpdated(event, emit),
        _FontSizeUpdated() => _onFontSizeUpdated(event, emit),
        _ColorUpdated() => _onColorUpdated(event, emit),
        _ShowMillisecondsToggled() => _onShowMillisecondsToggled(event, emit),
        _ShowProgressBarToggled() => _onShowProgressBarToggled(event, emit),
        _TransparentNotFoundTxtToggled() => _onTransparentNotFoundTxtUpdated(
          event,
          emit,
        ),
        _ShowLine2Toggled() => _onShowLine2Toggled(event, emit),
        _EnableAnimationToggled() => _onEnableAnimationToggled(event, emit),
        _AnimationModeUpdated() => _onAnimationModeUpdated(event, emit),
        _ToleranceUpdated() => _onToleranceUpdated(event, emit),
        _WindowIgnoreTouchToggled() => _onWindowIgnoreTouchToggled(event, emit),
        _WindowTouchThroughToggled() => _onWindowTouchThroughToggled(
          event,
          emit,
        ),
        _AutoFetchOnlineToggled() => _onAutoFetchOnlineToggled(event, emit),
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

  Future<void> _onWindowColorThemeToggled(
    _WindowColorThemeToggled event,
    Emitter<PreferenceState> emit,
  ) async {
    final isSuccess = await _preferenceRepo.toggleUseAppColor(event.value);
    if (isSuccess) {
      emit(state.copyWith(useAppColor: event.value));
    }
  }

  Future<void> _onBackgroundColorUpdated(
    _BackgroundColorUpdated event,
    Emitter<PreferenceState> emit,
  ) async {
    final isSuccess = await _preferenceRepo.updateBackgroundColor(event.color);
    if (isSuccess) {
      emit(state.copyWith(backgroundColor: event.color));
    }
  }

  Future<void> _onOpacityUpdated(
    _OpacityUpdated event,
    Emitter<PreferenceState> emit,
  ) async {
    final isSuccess = await _preferenceRepo.updateOpacity(event.opacity);
    if (isSuccess) {
      emit(state.copyWith(opacity: event.opacity));
    }
  }

  Future<void> _onFontSizeUpdated(
    _FontSizeUpdated event,
    Emitter<PreferenceState> emit,
  ) async {
    final fontSize = event.fontSize.toInt();
    final isSuccess = await _preferenceRepo.updateFontSize(fontSize);
    if (isSuccess) {
      emit(state.copyWith(fontSize: fontSize));
    }
  }

  Future<void> _onColorUpdated(
    _ColorUpdated event,
    Emitter<PreferenceState> emit,
  ) async {
    final isSuccess = await _preferenceRepo.updateColor(event.color);
    if (isSuccess) {
      emit(state.copyWith(color: event.color));
    }
  }

  Future<void> _onShowMillisecondsToggled(
    _ShowMillisecondsToggled event,
    Emitter<PreferenceState> emit,
  ) async {
    final isSuccess = await _preferenceRepo.toggleShowMilliseconds(event.value);
    if (isSuccess) {
      emit(state.copyWith(showMilliseconds: event.value));
    }
  }

  Future<void> _onShowProgressBarToggled(
    _ShowProgressBarToggled event,
    Emitter<PreferenceState> emit,
  ) async {
    final isSuccess = await _preferenceRepo.toggleShowProgressBar(event.value);
    if (isSuccess) {
      emit(state.copyWith(showProgressBar: event.value));
    }
  }

  Future<void> _onTransparentNotFoundTxtUpdated(
    _TransparentNotFoundTxtToggled event,
    Emitter<PreferenceState> emit,
  ) async {
    final isSuccess = await _preferenceRepo.updateTransparentNotFoundTxt(
      event.value,
    );
    if (isSuccess) {
      emit(state.copyWith(transparentNotFoundTxt: event.value));
    }
  }

  Future<void> _onShowLine2Toggled(
    _ShowLine2Toggled event,
    Emitter<PreferenceState> emit,
  ) async {
    final isSuccess = await _preferenceRepo.toggleShowLine2(event.value);
    if (isSuccess) {
      emit(state.copyWith(showLine2: event.value));
    }
  }

  Future<void> _onEnableAnimationToggled(
    _EnableAnimationToggled event,
    Emitter<PreferenceState> emit,
  ) async {
    final isSuccess = await _preferenceRepo.toggleEnableAnimation(event.value);
    if (isSuccess) {
      emit(state.copyWith(enableAnimation: event.value));
    }
  }

  Future<void> _onAnimationModeUpdated(
    _AnimationModeUpdated event,
    Emitter<PreferenceState> emit,
  ) async {
    final isSuccess = await _preferenceRepo.updateAnimationMode(event.mode);
    if (isSuccess) {
      emit(state.copyWith(animationMode: event.mode));
    }
  }

  Future<void> _onToleranceUpdated(
    _ToleranceUpdated event,
    Emitter<PreferenceState> emit,
  ) async {
    final isSuccess = await _preferenceRepo.updateTolerance(event.tolerance);
    if (isSuccess) {
      emit(state.copyWith(tolerance: event.tolerance));
    }
  }

  Future<void> _onWindowIgnoreTouchToggled(
    _WindowIgnoreTouchToggled event,
    Emitter<PreferenceState> emit,
  ) async {
    // TODO(@Felix)
    // final isSuccess = await _preferenceRepo.toggleWindowIgnoreTouch(
    //   event.value,
    // );
    // if (isSuccess) {
    //   emit(state.copyWith(windowIgnoreTouch: event.value));
    // }
  }

  Future<void> _onWindowTouchThroughToggled(
    _WindowTouchThroughToggled event,
    Emitter<PreferenceState> emit,
  ) async {
    // TODO(@Felix)
    // final isSuccess = await _preferenceRepo.toggleWindowTouchThrough(
    //   event.value,
    // );
    // if (isSuccess) {
    //   emit(state.copyWith(windowTouchThrough: event.value));
    // }
  }

  Future<void> _onAutoFetchOnlineToggled(
    _AutoFetchOnlineToggled event,
    Emitter<PreferenceState> emit,
  ) async {
    final isSuccess = await _preferenceRepo.toggleAutoFetchOnline(
      !state.autoFetchOnline,
    );
    if (isSuccess) {
      emit(state.copyWith(autoFetchOnline: !state.autoFetchOnline));
    }
  }
}

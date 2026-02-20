import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
          visibleLinesCount: preferenceRepo.visibleLinesCount,
          useAppColor: preferenceRepo.useAppColor,
          tolerance: preferenceRepo.tolerance,
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
        _VisibleLinesCountUpdated() => _onVisibleLinesCountUpdated(event, emit),
        _ToleranceUpdated() => _onToleranceUpdated(event, emit),
        _WindowIgnoreTouchToggled() => _onWindowIgnoreTouchToggled(event, emit),
        _WindowTouchThroughToggled() => _onWindowTouchThroughToggled(
          event,
          emit,
        ),
        _AutoFetchOnlineToggled() => _onAutoFetchOnlineToggled(event, emit),
        _BrightnessToggled() => _onBrightnessToggled(event, emit),
        _AppColorSchemeUpdated() => _onAppColorSchemeUpdated(event, emit),
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

  Future<void> _onVisibleLinesCountUpdated(
    _VisibleLinesCountUpdated event,
    Emitter<PreferenceState> emit,
  ) async {
    final isSuccess = await _preferenceRepo.updateVisibleLinesCount(
      event.count,
    );
    if (isSuccess) {
      emit(state.copyWith(visibleLinesCount: event.count));
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

  Future<void> _onBrightnessToggled(
    _BrightnessToggled event,
    Emitter<PreferenceState> emit,
  ) async {
    final isSuccess = await _preferenceRepo.toggleBrightness(!state.isLight);
    if (isSuccess) {
      emit(state.copyWith(isLight: !state.isLight));
    }
  }

  Future<void> _onAppColorSchemeUpdated(
    _AppColorSchemeUpdated event,
    Emitter<PreferenceState> emit,
  ) async {
    final isSuccess = await _preferenceRepo.updateAppColorScheme(event.color);
    if (isSuccess) {
      emit(state.copyWith(appColorScheme: event.color));
    }
  }
}

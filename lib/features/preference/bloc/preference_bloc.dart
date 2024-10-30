import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../repos/local/preference_repo.dart';
import '../../../service/preference/preference_service.dart';

part 'preference_bloc.freezed.dart';
part 'preference_bloc.g.dart';
part 'preference_event.dart';
part 'preference_state.dart';

class PreferenceBloc extends Bloc<PreferenceEvent, PreferenceState> {
  PreferenceBloc({
    required PreferenceService spService,
  })  : _spService = spService,
        super(PreferenceState(
          opacity: spService.opacity,
          color: spService.color,
          backgroundColor: spService.backgroundColor,
          isLight: spService.isLight,
          appColorScheme: spService.appColorScheme,
          showMilliseconds: spService.showMilliseconds,
          showProgressBar: spService.showProgressBar,
          fontFamily: spService.fontFamily,
          fontSize: spService.fontSize,
          autoFetchOnline: spService.autoFetchOnline,
          showLine2: spService.showLine2,
          useAppColor: spService.useAppColor,
          enableAnimation: spService.enableAnimation,
          tolerance: spService.tolerance,
        )) {
    on<PreferenceEvent>((event, emit) => switch (event) {
          PreferenceEventLoad() => _onLoaded(emit),
          OpacityUpdated() => _onOpacityUpdated(event, emit),
          ColorUpdated() => _onColorUpdated(event, emit),
          BackgroundColorUpdated() => _onBackgroundColorUpdated(event, emit),
          BrightnessToggled() => _onBrightnessToggled(event, emit),
          AppColorSchemeUpdated() => _onAppColorSchemeUpdated(event, emit),
          ShowMillisecondsToggled() => _onShowMillisecondsToggled(event, emit),
          ShowProgressBarToggled() => _onShowProgressBarToggled(event, emit),
          FontSizeUpdated() => _onFontSizeUpdated(event, emit),
          AutoFetchOnlineToggled() => _onAutoFetchOnlineToggled(event, emit),
          ShowLine2Toggled() => _onShowLine2Toggled(event, emit),
          WindowColorThemeToggled() => _onWindowColorThemeToggled(event, emit),
          FontFamilyUpdated() => _onFontFamilyUpdated(event, emit),
          FontFamilyReset() => _onFontFamilyReset(event, emit),
          EnableAnimationToggled() => _onEnableAnimationToggled(event, emit),
          ToleranceUpdated() => _onToleranceUpdated(event, emit),
        });
  }

  final PreferenceService _spService;

  void _onLoaded(Emitter<PreferenceState> emit) {}

  Future<void> _onOpacityUpdated(OpacityUpdated event, Emitter<PreferenceState> emit) async {
    final isSuccess = await _spService.updateOpacity(event.value);
    if (isSuccess) {
      emit(state.copyWith(opacity: event.value));
    }
  }

  Future<void> _onColorUpdated(ColorUpdated event, Emitter<PreferenceState> emit) async {
    final isSuccess = await _spService.updateColor(event.color);
    if (isSuccess) {
      emit(state.copyWith(color: event.color.value));
    }
  }

  Future<void> _onBackgroundColorUpdated(BackgroundColorUpdated event, Emitter<PreferenceState> emit) async {
    final isSuccess = await _spService.updateBackgroundColor(event.color);
    if (isSuccess) {
      emit(state.copyWith(backgroundColor: event.color.value));
    }
  }

  Future<void> _onBrightnessToggled(BrightnessToggled event, Emitter<PreferenceState> emit) async {
    final isSuccess = await _spService.toggleBrightness(!state.isLight);
    if (isSuccess) {
      emit(state.copyWith(isLight: !state.isLight));
    }
  }

  Future<void> _onAppColorSchemeUpdated(AppColorSchemeUpdated event, Emitter<PreferenceState> emit) async {
    final isSuccess = await _spService.updateAppColorScheme(event.color.value);
    if (isSuccess) {
      emit(state.copyWith(appColorScheme: event.color.value));
    }
  }

  Future<void> _onShowMillisecondsToggled(ShowMillisecondsToggled event, Emitter<PreferenceState> emit) async {
    final isSuccess = await _spService.toggleShowMilliseconds(!state.showMilliseconds);
    if (isSuccess) {
      emit(state.copyWith(showMilliseconds: !state.showMilliseconds));
    }
  }

  Future<void> _onShowProgressBarToggled(ShowProgressBarToggled event, Emitter<PreferenceState> emit) async {
    final isSuccess = await _spService.toggleShowProgressBar(!state.showProgressBar);
    if (isSuccess) {
      emit(state.copyWith(showProgressBar: !state.showProgressBar));
    }
  }

  Future<void> _onFontSizeUpdated(FontSizeUpdated event, Emitter<PreferenceState> emit) async {
    final isSuccess = await _spService.updateFontSize(event.fontSize);
    if (isSuccess) {
      emit(state.copyWith(fontSize: event.fontSize));
    }
  }

  Future<void> _onAutoFetchOnlineToggled(AutoFetchOnlineToggled event, Emitter<PreferenceState> emit) async {
    final isSuccess = await _spService.toggleAutoFetchOnline(!state.autoFetchOnline);
    if (isSuccess) {
      emit(state.copyWith(autoFetchOnline: !state.autoFetchOnline));
    }
  }

  Future<void> _onShowLine2Toggled(ShowLine2Toggled event, Emitter<PreferenceState> emit) async {
    final isSuccess = await _spService.toggleShowLine2(!state.showLine2);
    if (isSuccess) {
      emit(state.copyWith(showLine2: !state.showLine2));
    }
  }

  Future<void> _onWindowColorThemeToggled(WindowColorThemeToggled event, Emitter<PreferenceState> emit) async {
    final isSuccess = await _spService.toggleUseAppColor(event.useAppColor);
    if (isSuccess) {
      emit(state.copyWith(useAppColor: event.useAppColor));
    }
  }

  Future<void> _onFontFamilyUpdated(FontFamilyUpdated event, Emitter<PreferenceState> emit) async {
    final isSuccess = await _spService.updateFontFamily(event.fontFamily);
    if (isSuccess) {
      emit(state.copyWith(fontFamily: event.fontFamily));
    }
  }

  Future<void> _onFontFamilyReset(FontFamilyReset event, Emitter<PreferenceState> emit) async {
    final isSuccess = await _spService.resetFontFamily();
    if (isSuccess) {
      emit(state.copyWith(fontFamily: PreferenceRepo.defaultFont));
    }
  }

  Future<void> _onEnableAnimationToggled(EnableAnimationToggled event, Emitter<PreferenceState> emit) async {
    final isSuccess = await _spService.toggleEnableAnimation(!state.enableAnimation);
    if (isSuccess) {
      emit(state.copyWith(enableAnimation: !state.enableAnimation));
    }
  }

  Future<void> _onToleranceUpdated(ToleranceUpdated event, Emitter<PreferenceState> emit) async {
    final isSuccess = await _spService.updateTolerance(event.tolerance);
    if (isSuccess) {
      emit(state.copyWith(tolerance: event.tolerance));
    }
  }
}

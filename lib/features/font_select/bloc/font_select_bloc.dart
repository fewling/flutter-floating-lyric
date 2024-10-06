import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_fonts/google_fonts.dart';

part 'font_select_bloc.freezed.dart';
part 'font_select_event.dart';
part 'font_select_state.dart';

class FontSelectBloc extends Bloc<FontSelectEvent, FontSelectState> {
  FontSelectBloc() : super(const FontSelectState()) {
    on<FontSelectEvent>(
      (event, emit) => switch (event) {
        FontSelectStarted() => _onStarted(event, emit),
        FontSelectSearchChanged() => _onSearchChanged(event, emit),
      },
    );
  }

  void _onStarted(FontSelectStarted event, Emitter<FontSelectState> emit) {
    final fontMap = GoogleFonts.asMap();
    final fontStyles = <String, TextStyle>{};

    fontMap.forEach((key, value) => fontStyles[key] = value());

    emit(state.copyWith(
      fontStyles: fontStyles,
      filteredFontStyles: fontStyles,
    ));
  }

  void _onSearchChanged(FontSelectSearchChanged event, Emitter<FontSelectState> emit) {
    final filteredFontStyles = <String, TextStyle>{};

    if (event.searchTerm.isEmpty) {
      emit(state.copyWith(filteredFontStyles: state.fontStyles));
      return;
    }

    state.fontStyles.forEach((key, value) {
      if (key.toLowerCase().contains(event.searchTerm.toLowerCase())) {
        filteredFontStyles[key] = value;
      }
    });

    emit(state.copyWith(filteredFontStyles: filteredFontStyles));
  }
}

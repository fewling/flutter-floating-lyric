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
        FontSelectLoadMore() => _onLoadMore(event, emit),
      },
    );
  }

  void _onStarted(FontSelectStarted event, Emitter<FontSelectState> emit) {
    final keys = GoogleFonts.asMap().keys;
    final fontStyles = <String, TextStyle>{};

    for (var i = 0; i < state.limit; i++) {
      final key = keys.elementAt(state.offset + i);
      fontStyles[key] = GoogleFonts.getFont(key);
    }

    emit(state.copyWith(
      fontStyles: fontStyles,
      filteredFontStyles: fontStyles,
      offset: state.offset + state.limit,
    ));
  }

  void _onSearchChanged(FontSelectSearchChanged event, Emitter<FontSelectState> emit) {
    if (event.searchTerm.isEmpty) {
      emit(state.copyWith(filteredFontStyles: state.fontStyles));
      return;
    }

    final fontStyles = {...state.fontStyles};
    final filteredFontStyles = <String, TextStyle>{};
    final keys = GoogleFonts.asMap().keys;

    for (var i = 0; i < keys.length; i++) {
      final key = keys.elementAt(i);
      if (key.toLowerCase().contains(event.searchTerm.toLowerCase())) {
        final txtStyle = GoogleFonts.getFont(key);
        fontStyles[key] = txtStyle;
        filteredFontStyles[key] = txtStyle;
      }
    }

    emit(state.copyWith(
      fontStyles: fontStyles,
      filteredFontStyles: filteredFontStyles,
    ));
  }

  void _onLoadMore(FontSelectLoadMore event, Emitter<FontSelectState> emit) {
    final keys = GoogleFonts.asMap().keys;
    final fontStyles = {...state.fontStyles};

    for (var i = 0; i < state.limit; i++) {
      if (state.offset + i >= keys.length) break;

      final key = keys.elementAt(state.offset + i);
      fontStyles[key] = GoogleFonts.getFont(key);
    }

    emit(state.copyWith(
      fontStyles: fontStyles,
      filteredFontStyles: fontStyles,
      offset: state.offset + state.limit,
    ));
  }
}

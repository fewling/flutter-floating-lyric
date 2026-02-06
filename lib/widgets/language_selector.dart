import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../configs/locale_constants.dart';
import '../features/preference/bloc/preference_bloc.dart';
import '../utils/extensions/custom_extensions.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  static String getLocaleDisplayName(BuildContext context, String locale) {
    final l10n = context.l10n;
    switch (locale) {
      case LocaleConstants.english:
        return l10n.language_english;
      case LocaleConstants.chinese:
        return l10n.language_chinese;
      default:
        return l10n.language_english; // Fallback to English for unknown locales
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentLocale = context.select<PreferenceBloc, String>(
      (bloc) => bloc.state.locale,
    );

    return PopupMenuButton<String>(
      initialValue: currentLocale,
      onSelected: (String locale) {
        context.read<PreferenceBloc>().add(LocaleUpdated(locale));
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: LocaleConstants.english,
          child: Text(l10n.language_english),
        ),
        PopupMenuItem<String>(
          value: LocaleConstants.chinese,
          child: Text(l10n.language_chinese),
        ),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            excludeSemantics: true,
            child: const Icon(Icons.language),
          ),
          const SizedBox(width: 8),
          Text(getLocaleDisplayName(context, currentLocale)),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}

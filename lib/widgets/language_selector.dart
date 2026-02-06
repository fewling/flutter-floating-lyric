import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/preference/bloc/preference_bloc.dart';
import '../utils/extensions/custom_extensions.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

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
          value: 'en',
          child: Text(l10n.language_english),
        ),
        PopupMenuItem<String>(
          value: 'zh',
          child: Text(l10n.language_chinese),
        ),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currentLocale == 'en'
                ? l10n.language_english
                : l10n.language_chinese,
          ),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}

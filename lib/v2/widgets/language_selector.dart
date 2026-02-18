import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/preference/preference_bloc.dart';
import '../enums/app_locale.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({required this.value, super.key});

  final AppLocale value;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      initialValue: value,
      onSelected: (locale) => context.read<PreferenceBloc>().add(
        PreferenceEvent.localeUpdated(locale),
      ),
      itemBuilder: (context) => [
        for (final locale in AppLocale.values)
          PopupMenuItem(value: locale, child: Text(locale.displayName)),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Text(value.displayName), const Icon(Icons.arrow_drop_down)],
      ),
    );
  }
}

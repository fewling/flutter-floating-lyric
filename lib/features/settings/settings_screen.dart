import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/extensions/custom_extensions.dart';
import '../../widgets/color_picker_sheet.dart';
import '../../widgets/language_selector.dart';
import '../preference/bloc/preference_bloc.dart';
import 'bloc/settings_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.primary;

    return Scaffold(
      body: ListView(
        children: [
          Builder(
            builder: (context) {
              final currentLocale = context.select<PreferenceBloc, String>(
                (bloc) => bloc.state.locale,
              );

              return ListTile(
                leading: Icon(Icons.language_outlined, color: primary),
                title: Text(l10n.language),
                subtitle: Text(
                  LanguageSelector.getLocaleDisplayName(context, currentLocale),
                ),
                trailing: const LanguageSelector(),
              );
            },
          ),
          Builder(
            builder: (context) => ListTile(
              leading: Icon(Icons.brightness_2_outlined, color: primary),
              title: Text(l10n.settings_use_dark_mode),
              onTap: () =>
                  context.read<PreferenceBloc>().add(const BrightnessToggled()),
              trailing: Switch(
                onChanged: (_) => context.read<PreferenceBloc>().add(
                  const BrightnessToggled(),
                ),
                value: colorScheme.brightness == Brightness.dark,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.color_lens_outlined, color: primary),
            title: Text(l10n.settings_color_scheme),
            trailing: Icon(Icons.square, color: colorScheme.primary),
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (modalCtx) => BlocProvider.value(
                value: context.read<PreferenceBloc>(),
                child: ColorPickerSheet(
                  colorValue: context
                      .watch<PreferenceBloc>()
                      .state
                      .appColorScheme,
                  onColorChanged: (color) => context.read<PreferenceBloc>().add(
                    AppColorSchemeUpdated(color),
                  ),
                ),
              ),
            ),
          ),
          Builder(
            builder: (context) => ListTile(
              leading: Icon(Icons.email_outlined, color: primary),
              title: Text(l10n.settings_bug_report_feature_request),
              subtitle: Text(l10n.settings_send_feedback),
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
              onTap: () => context.read<SettingsBloc>().add(
                const FeedbackEmailClicked(),
              ),
            ),
          ),

          const Divider(),

          ListTile(
            leading: Icon(Icons.info_outline, color: primary),
            title: Text(l10n.settings_known_issues),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SelectionArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.settings_known_issues_issue1),
                  Text(l10n.settings_known_issues_issue2),
                  Text(l10n.settings_known_issues_issue3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

part of 'page.dart';

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final primary = colorScheme.primary;

    final appInfo = MainAppDependency.of(context).watch<AppInfoBloc>().state;
    final pref = MainAppDependency.of(context).watch<PreferenceBloc>().state;

    final version = appInfo.version ?? '';
    final buildNumber = appInfo.buildNumber ?? '';
    final currentLocale = pref.locale;

    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.language_outlined, color: primary),
            title: Text(l10n.language),
            subtitle: Text(currentLocale.displayName),
            trailing: LanguageSelector(value: currentLocale),
          ),

          ListTile(
            leading: Icon(Icons.brightness_2_outlined, color: primary),
            title: Text(l10n.settings_use_dark_mode),
            onTap: () => context.read<PreferenceBloc>().add(
              const PreferenceEvent.brightnessToggled(),
            ),
            trailing: Switch(
              onChanged: (_) => context.read<PreferenceBloc>().add(
                const PreferenceEvent.brightnessToggled(),
              ),
              value: colorScheme.brightness == Brightness.dark,
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
                    PreferenceEvent.appColorSchemeUpdated(color.toARGB32()),
                  ),
                ),
              ),
            ),
          ),

          ListTile(
            leading: Icon(Icons.email_outlined, color: primary),
            title: Text(l10n.settings_bug_report_feature_request),
            subtitle: Text(l10n.settings_send_feedback),
            trailing: const Icon(Icons.arrow_forward_ios_outlined),
            onTap: () => context.read<SettingsBloc>().add(
              const SettingsEvent.feedbackEmail(),
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: Chip(label: Text('$version ($buildNumber)')),
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

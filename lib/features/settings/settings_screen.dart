import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/color_picker_sheet.dart';
import '../app_info/bloc/app_info_bloc.dart';
import '../preference/bloc/preference_bloc.dart';
import 'bloc/settings_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.primary;

    return Scaffold(
      body: ListView(
        children: [
          // ListTile(
          //   leading: Icon(Icons.language_outlined, color: primary),
          //   title: const Text('Language'),
          //   onTap: () {},
          //   trailing: const Icon(Icons.arrow_forward_ios_outlined),
          // ),
          Builder(
            builder: (context) => ListTile(
              leading: Icon(Icons.brightness_2_outlined, color: primary),
              title: const Text('Use Dark Mode'),
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
            title: const Text('Color Scheme'),
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
              title: const Text('Bug Report/Feature Request'),
              subtitle: const Text('Send us your feedback'),
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
              onTap: () => context.read<SettingsBloc>().add(
                const FeedbackEmailClicked(),
              ),
            ),
          ),
          Builder(
            builder: (context) {
              final version = context.select<AppInfoBloc, String>(
                (bloc) => bloc.state.version ?? '',
              );

              final buildNumber = context.select<AppInfoBloc, String>(
                (bloc) => bloc.state.buildNumber ?? '',
              );

              return Align(
                alignment: Alignment.centerRight,
                child: Chip(label: Text('$version ($buildNumber)')),
              );
            },
          ),

          const Divider(),

          ListTile(
            leading: Icon(Icons.info_outline, color: primary),
            title: const Text('Known Issues'),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: SelectionArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'In some heavy customized Android OS like MIUI, ColorOS, HuaWei: ',
                  ),
                  Text('1. Could not retrieve necessary permissions.'),
                  Text('2. Not detecting music app from notification bar.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

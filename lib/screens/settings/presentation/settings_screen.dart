import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/constants/app_info.dart';
import '../../../v4/features/preference/bloc/preference_bloc.dart';
import '../../../widgets/color_picker_sheet.dart';
import 'settings_notifier.dart';

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
          Consumer(
            builder: (context, ref, child) => ListTile(
              leading: Icon(Icons.brightness_2_outlined, color: primary),
              title: const Text('Use Dark Mode'),
              onTap: () => context.read<PreferenceBloc>().add(const BrightnessToggled()),
              trailing: Switch(
                onChanged: (_) => context.read<PreferenceBloc>().add(const BrightnessToggled()),
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
                  colorValue: context.watch<PreferenceBloc>().state.color,
                  onColorChanged: (color) => context.read<PreferenceBloc>().add(ColorUpdated(color)),
                ),
              ),
            ),
          ),
          Consumer(
            builder: (context, ref, child) => ListTile(
              leading: Icon(Icons.email_outlined, color: primary),
              title: const Text('Bug Report/Feature Request'),
              subtitle: const Text('Send us your feedback'),
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
              onTap: ref.read(settingsNotifierProvider.notifier).launchFeedbackEmail,
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final version = ref.watch(versionProvider).when(
                    data: (data) => data,
                    error: (error, stack) => 'Error: $error',
                    loading: () => '...',
                  );
              final buildNumber = ref.watch(buildNumberProvider).when(
                    data: (data) => data,
                    error: (error, stack) => 'Error: $error',
                    loading: () => '...',
                  );

              return Align(
                alignment: Alignment.centerRight,
                child: Chip(
                  label: Text('$version ($buildNumber)'),
                ),
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
                  Text('In some heavy customized Android OS like MIUI, ColorOS, HuaWei: '),
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
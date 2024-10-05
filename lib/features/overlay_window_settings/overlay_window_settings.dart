import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../preference/bloc/preference_bloc.dart';
import 'bloc/overlay_window_settings_bloc.dart';

class OverlayWindowSetting extends StatelessWidget {
  const OverlayWindowSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final visibleFloatingWindow = context.select<OverlayWindowSettingsBloc, bool>(
      (bloc) => bloc.state.isWindowVisible,
    );

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            title: const Text('Enable'),
            value: visibleFloatingWindow,
            onChanged: (value) => context.read<OverlayWindowSettingsBloc>().add(OverlayWindowVisibilityToggled(value)),
          ),
          Builder(
            builder: (context) {
              final showMillis = context.select<PreferenceBloc, bool>(
                (bloc) => bloc.state.showMilliseconds,
              );

              return ListTile(
                enabled: visibleFloatingWindow,
                leading: const Icon(Icons.timelapse_outlined),
                title: showMillis ? const Text('Show Milliseconds') : const Text('Hide Milliseconds'),
                trailing: Switch(
                  value: showMillis,
                  onChanged: !visibleFloatingWindow
                      ? null
                      : (value) => context.read<PreferenceBloc>().add(const ShowMillisecondsToggled()),
                ),
              );
            },
          ),
          Builder(
            builder: (context) {
              final showBar = context.select<PreferenceBloc, bool>(
                (bloc) => bloc.state.showProgressBar,
              );

              return ListTile(
                enabled: visibleFloatingWindow,
                leading: const Icon(Icons.linear_scale_outlined),
                title: showBar ? const Text('Show Progress Bar') : const Text('Hide Progress Bar'),
                trailing: Switch(
                  value: showBar,
                  onChanged: !visibleFloatingWindow
                      ? null
                      : (value) => context.read<PreferenceBloc>().add(const ShowProgressBarToggled()),
                ),
              );
            },
          ),
          Builder(
            builder: (context) {
              final showLine2 = context.select<PreferenceBloc, bool>(
                (bloc) => bloc.state.showLine2,
              );

              return ListTile(
                enabled: visibleFloatingWindow,
                leading: const Icon(Icons.linear_scale_outlined),
                title: showLine2 ? const Text('Show Line 2') : const Text('Hide Line 2'),
                trailing: Switch(
                  value: showLine2,
                  onChanged: !visibleFloatingWindow
                      ? null
                      : (value) => context.read<PreferenceBloc>().add(const ShowLine2Toggled()),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Color Scheme'),
            leading: const Icon(Icons.color_lens_outlined),
            enabled: visibleFloatingWindow,
            trailing: Builder(builder: (context) {
              final color = context.select<PreferenceBloc, int>(
                (bloc) => bloc.state.color,
              );

              return ColoredBox(
                color: Color(color),
                child: const SizedBox(width: 24, height: 24),
              );
            }),
            onTap: () => showDialog(
              builder: (dialogCtx) => BlocProvider.value(
                value: context.read<PreferenceBloc>(),
                child: AlertDialog(
                  title: const Text('Pick a color!'),
                  content: SingleChildScrollView(
                    child: Builder(
                      builder: (context) {
                        final color = context.select<PreferenceBloc, int>(
                          (bloc) => bloc.state.color,
                        );

                        return ColorPicker(
                          pickerColor: Color(color),
                          onColorChanged: (value) => context.read<PreferenceBloc>().add(ColorUpdated(value)),
                          paletteType: PaletteType.hueWheel,
                          hexInputBar: true,
                        );
                      },
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(dialogCtx).pop(),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              ),
              context: context,
            ),
          ),
          ListTile(
            enabled: visibleFloatingWindow,
            leading: const Icon(Icons.opacity_outlined),
            trailing: Builder(
              builder: (context) {
                final opacity = context.select<PreferenceBloc, double>(
                  (bloc) => bloc.state.opacity,
                );

                return Text('${opacity.toInt()}%');
              },
            ),
            title: const Text('Window Opacity'),
          ),
          Builder(
            builder: (context) {
              final opacity = context.select<PreferenceBloc, double>(
                (bloc) => bloc.state.opacity,
              );
              return Slider(
                max: 100,
                divisions: 20,
                value: opacity,
                label: '${opacity.toInt()}%',
                onChanged: visibleFloatingWindow ? (o) => context.read<PreferenceBloc>().add(OpacityUpdated(o)) : null,
              );
            },
          ),
          ListTile(
            enabled: visibleFloatingWindow,
            leading: const Icon(Icons.format_size_outlined),
            trailing: Builder(
              builder: (context) {
                final fontSize = context.select<PreferenceBloc, int>(
                  (bloc) => bloc.state.fontSize,
                );

                return Text('$fontSize');
              },
            ),
            title: const Text('Lyrics Font Size'),
          ),
          Builder(
            builder: (context) {
              final fontSize = context.select<PreferenceBloc, int>(
                (bloc) => bloc.state.fontSize,
              );

              return Slider(
                min: 4,
                max: 72,
                value: fontSize.toDouble(),
                label: '$fontSize%',
                onChanged: visibleFloatingWindow
                    ? (value) => context.read<PreferenceBloc>().add(FontSizeUpdated(value.toInt()))
                    : null,
              );
            },
          ),
          ListTile(
            title: const Text('Window Interactions'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(
                  builder: (context) {
                    final isIgnoreTouch = context.select<OverlayWindowSettingsBloc, bool>(
                      (bloc) => bloc.state.isIgnoreTouch,
                    );
                    return SegmentedButton(
                      selected: {isIgnoreTouch},
                      onSelectionChanged: (v) =>
                          context.read<OverlayWindowSettingsBloc>().add(WindowIgnoreTouchToggled(v.first)),
                      segments: [
                        ButtonSegment(
                          value: false,
                          label: const Text('Handle Touch'),
                          icon: const Icon(Icons.touch_app_outlined),
                          enabled: visibleFloatingWindow,
                        ),
                        ButtonSegment(
                          value: true,
                          label: const Text('Ignore Touch'),
                          icon: const Icon(Icons.do_not_touch_outlined),
                          enabled: visibleFloatingWindow,
                        ),
                      ],
                    );
                  },
                ),
                Builder(
                  builder: (context) {
                    final isTouchThru = context.select<OverlayWindowSettingsBloc, bool>(
                      (bloc) => bloc.state.isTouchThru,
                    );
                    return SwitchListTile(
                      value: isTouchThru,
                      title: const Text('Touch Through ⚠️'),
                      subtitle: isTouchThru
                          ? const Text(
                              'This will disable back gesture, keyboard and maybe something else. So use it at your own risk.\n'
                              "Such issue is due to Android's design limitation and is out of this app's control. 🙏",
                            )
                          : null,
                      onChanged: visibleFloatingWindow
                          ? (_) => context.read<OverlayWindowSettingsBloc>().add(const WindowTouchThroughToggled())
                          : null,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

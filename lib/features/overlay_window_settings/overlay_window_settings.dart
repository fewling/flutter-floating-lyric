import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';

import '../../configs/routes/app_router.dart';
import '../preference/bloc/preference_bloc.dart';
import 'bloc/overlay_window_settings_bloc.dart';

class OverlayWindowSetting extends StatelessWidget {
  const OverlayWindowSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final visibleFloatingWindow = context.select<OverlayWindowSettingsBloc, bool>(
      (bloc) => bloc.state.isWindowVisible,
    );

    final useAppColor = context.select((PreferenceBloc b) => b.state.useAppColor);
    final useCustomColor = !useAppColor;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            context.read<OverlayWindowSettingsBloc>().add(OverlayWindowVisibilityToggled(!visibleFloatingWindow)),
        icon: visibleFloatingWindow ? const Icon(Icons.hide_source) : const Icon(Icons.play_arrow_outlined),
        label: visibleFloatingWindow ? const Text('Hide') : const Text('Show'),
      ),
      body: SingleChildScrollView(
        child: ExpansionPanelList.radio(
          initialOpenPanelValue: 0,
          children: [
            ExpansionPanelRadio(
              canTapOnHeader: true,
              value: 0,
              headerBuilder: (context, isExpanded) => ListTile(
                title: const Text('Styling'),
                leading: const Icon(Icons.style_outlined),
                selected: isExpanded,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: useAppColor,
                      title: const Text('Use App Color'),
                      secondary: const Icon(Icons.palette_outlined),
                      onChanged: !visibleFloatingWindow
                          ? null
                          : (value) => context.read<PreferenceBloc>().add(WindowColorThemeToggled(value)),
                    ),
                    ListTile(
                      enabled: visibleFloatingWindow && useCustomColor,
                      title: const Text('Custom Backgound Color'),
                      leading: const Icon(Icons.color_lens_outlined),
                      trailing: Builder(builder: (context) {
                        final color = context.select<PreferenceBloc, int>(
                          (bloc) => bloc.state.backgroundColor,
                        );

                        return ColoredBox(
                          color: Color(color).withOpacity(useCustomColor ? 1 : 0.5),
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
                                    (bloc) => bloc.state.backgroundColor,
                                  );

                                  return ColorPicker(
                                    pickerColor: Color(color),
                                    onColorChanged: (value) =>
                                        context.read<PreferenceBloc>().add(BackgroundColorUpdated(value)),
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
                          onChanged: visibleFloatingWindow
                              ? (o) => context.read<PreferenceBloc>().add(OpacityUpdated(o))
                              : null,
                        );
                      },
                    ),
                    ListTile(
                      enabled: visibleFloatingWindow,
                      leading: const Icon(Icons.font_download_outlined),
                      trailing: Text(DefaultTextStyle.of(context).style.fontFamily ?? ''),
                      title: const Text('Font Family'),
                      onTap: () => context.goNamed(AppRoute.fonts.name),
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
                      enabled: visibleFloatingWindow && useCustomColor,
                      title: const Text('Custom Text Color'),
                      leading: const Icon(Icons.color_lens_outlined),
                      trailing: Builder(builder: (context) {
                        final color = context.select<PreferenceBloc, int>(
                          (bloc) => bloc.state.color,
                        );

                        return ColoredBox(
                          color: Color(color).withOpacity(useCustomColor ? 1 : 0.5),
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
                  ],
                ),
              ),
            ),
            ExpansionPanelRadio(
              canTapOnHeader: true,
              value: 1,
              headerBuilder: (context, isExpanded) => ListTile(
                title: const Text('Element Visibilities'),
                leading: const Icon(Icons.visibility_outlined),
                selected: isExpanded,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
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
                  ],
                ),
              ),
            ),
            ExpansionPanelRadio(
              canTapOnHeader: true,
              value: 2,
              headerBuilder: (context, isExpanded) => ListTile(
                title: const Text('Special Settings'),
                leading: const Icon(Icons.settings_suggest_outlined),
                selected: isExpanded,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Builder(builder: (context) {
                      final isIgnoreTouch = context.select<OverlayWindowSettingsBloc, bool>(
                        (bloc) => bloc.state.settings.ignoreTouch ?? false,
                      );
                      return SwitchListTile(
                        value: isIgnoreTouch,
                        title: const Text('Ignore Touch'),
                        subtitle: const Text(
                          'Enabling this will lock the window from moving too.\n'
                          'Disabling this will not unlock it.',
                        ),
                        secondary: const Icon(Icons.warning, color: Colors.orange),
                        onChanged: !visibleFloatingWindow
                            ? null
                            : (value) => context.read<OverlayWindowSettingsBloc>().add(WindowIgnoreTouchToggled(value)),
                      );
                    }),
                    Builder(
                      builder: (context) {
                        final isTouchThru = context.select<OverlayWindowSettingsBloc, bool>(
                          (bloc) => bloc.state.settings.touchThru ?? false,
                        );
                        return SwitchListTile(
                          value: isTouchThru,
                          secondary: const Icon(Icons.warning, color: Colors.red),
                          title: const Text('Touch Through'),
                          subtitle: const Text(
                            'This will disable back gesture, keyboard and maybe something else. So use it at your own risk.\n'
                            "Such issue is due to Android's design limitation and is out of this app's control. 🙏",
                          ),
                          onChanged: visibleFloatingWindow
                              ? (value) => context.read<OverlayWindowSettingsBloc>().add(WindowTouchThruToggled(value))
                              : null,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

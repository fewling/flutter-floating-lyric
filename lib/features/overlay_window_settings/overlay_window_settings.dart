import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';

import '../../configs/animation_modes.dart';
import '../../configs/routes/app_router.dart';
import '../../utils/extensions/custom_extensions.dart';
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
          expandedHeaderPadding: const EdgeInsets.all(16),
          children: [
            ExpansionPanelRadio(
              canTapOnHeader: true,
              value: 0,
              headerBuilder: (context, isExpanded) => ListTile(
                title: const Text('Styling', style: TextStyle(fontWeight: FontWeight.bold)),
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
                      trailing: Builder(builder: (ctx) => Text(ctx.select((PreferenceBloc b) => b.state.fontFamily))),
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
                title: const Text('Element Visibilities', style: TextStyle(fontWeight: FontWeight.bold)),
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

                        final title = Text(showMillis ? 'Show Milliseconds' : 'Hide Milliseconds');
                        const secondary = Icon(Icons.timelapse_outlined);

                        return ToggleableSwitchListTile(
                          enabled: visibleFloatingWindow,
                          value: showMillis,
                          title: title,
                          secondary: secondary,
                          onChanged: (value) => context.read<PreferenceBloc>().add(const ShowMillisecondsToggled()),
                        );
                      },
                    ),
                    Builder(
                      builder: (context) {
                        final showBar = context.select<PreferenceBloc, bool>(
                          (bloc) => bloc.state.showProgressBar,
                        );

                        final title = Text(showBar ? 'Show Progress Bar' : 'Hide Progress Bar');
                        const secondary = Icon(Icons.linear_scale_outlined);

                        return ToggleableSwitchListTile(
                          enabled: visibleFloatingWindow,
                          value: showBar,
                          title: title,
                          secondary: secondary,
                          onChanged: (value) => context.read<PreferenceBloc>().add(const ShowProgressBarToggled()),
                        );
                      },
                    ),
                    Builder(
                      builder: (context) {
                        final showLine2 = context.select<PreferenceBloc, bool>(
                          (bloc) => bloc.state.showLine2,
                        );

                        final title = Text(showLine2 ? 'Show Line 2' : 'Hide Line 2');
                        const secondary = Icon(Icons.linear_scale_outlined);

                        return ToggleableSwitchListTile(
                          enabled: visibleFloatingWindow,
                          value: showLine2,
                          title: title,
                          secondary: secondary,
                          onChanged: (value) => context.read<PreferenceBloc>().add(const ShowLine2Toggled()),
                        );
                      },
                    ),
                    Builder(
                      builder: (context) {
                        final enableAnimation = context.select<PreferenceBloc, bool>(
                          (bloc) => bloc.state.enableAnimation,
                        );

                        final title = Text(enableAnimation ? 'Enable Animation' : 'Disable Animation');
                        const secondary = Icon(Icons.animation_outlined);

                        return ToggleableSwitchListTile(
                          enabled: visibleFloatingWindow,
                          value: enableAnimation,
                          title: title,
                          secondary: secondary,
                          onChanged: (value) => context.read<PreferenceBloc>().add(const EnableAnimationToggled()),
                        );
                      },
                    ),
                    Builder(
                      builder: (context) {
                        final animationMode = context.select<PreferenceBloc, AnimationMode>(
                          (bloc) => bloc.state.animationMode,
                        );

                        final enableAnimation = context.select<PreferenceBloc, bool>(
                          (bloc) => bloc.state.enableAnimation,
                        );

                        return SegmentedButton(
                          selected: {animationMode},
                          segments: [
                            for (final mode in AnimationMode.values)
                              ButtonSegment(
                                value: mode,
                                label: Text(mode.name.capitalize()),
                              ),
                          ],
                          showSelectedIcon: false,
                          onSelectionChanged: !visibleFloatingWindow || !enableAnimation
                              ? null
                              : (Set<AnimationMode> selections) =>
                                  context.read<PreferenceBloc>().add(AnimationModeUpdated(selections.first)),
                        );
                      },
                    ),
                    ListTile(
                      enabled: visibleFloatingWindow,
                      leading: const Icon(Icons.hourglass_top_outlined),
                      trailing: Builder(
                        builder: (context) {
                          final tolerance = context.select<PreferenceBloc, int>(
                            (bloc) => bloc.state.tolerance,
                          );

                          return Text('$tolerance ms');
                        },
                      ),
                      title: const Text('Tolerance'),
                      subtitle: const Text('Increase this to make the lyrics ahead of the song, vice versa.'),
                    ),
                    Builder(
                      builder: (context) {
                        final tolerance = context.select<PreferenceBloc, int>(
                          (bloc) => bloc.state.tolerance,
                        );
                        return Slider(
                          min: -1000,
                          max: 1000,
                          divisions: 200,
                          value: tolerance.toDouble(),
                          label: '$tolerance',
                          onChanged: visibleFloatingWindow
                              ? (o) => context.read<PreferenceBloc>().add(ToleranceUpdated(o.toInt()))
                              : null,
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
                title: const Text('Special Settings', style: TextStyle(fontWeight: FontWeight.bold)),
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

class ToggleableSwitchListTile extends StatelessWidget {
  const ToggleableSwitchListTile({
    super.key,
    required this.enabled,
    required this.value,
    required this.title,
    required this.secondary,
    required this.onChanged,
  });

  final bool enabled;
  final bool value;
  final Widget title;
  final Widget secondary;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return enabled
        ? SwitchListTile(
            value: value,
            title: title,
            secondary: secondary,
            onChanged: onChanged,
          )
        : ListTile(
            enabled: false,
            leading: secondary,
            title: title,
            trailing: Switch(value: value, onChanged: null),
          );
  }
}

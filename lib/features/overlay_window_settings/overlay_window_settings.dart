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
    final l10n = context.l10n;
    final visibleFloatingWindow = context
        .select<OverlayWindowSettingsBloc, bool>(
          (bloc) => bloc.state.isWindowVisible,
        );

    final useAppColor = context.select(
      (PreferenceBloc b) => b.state.useAppColor,
    );
    final useCustomColor = !useAppColor;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.read<OverlayWindowSettingsBloc>().add(
          OverlayWindowVisibilityToggled(!visibleFloatingWindow),
        ),
        icon: visibleFloatingWindow
            ? const Icon(Icons.hide_source)
            : const Icon(Icons.play_arrow_outlined),
        label: visibleFloatingWindow
            ? Text(l10n.overlay_window_hide)
            : Text(l10n.overlay_window_show),
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
                title: Text(
                  l10n.overlay_window_styling,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: const Icon(Icons.style_outlined),
                selected: isExpanded,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: useAppColor,
                      title: Text(l10n.overlay_window_use_app_color),
                      secondary: const Icon(Icons.palette_outlined),
                      onChanged: !visibleFloatingWindow
                          ? null
                          : (value) => context.read<PreferenceBloc>().add(
                              WindowColorThemeToggled(value),
                            ),
                    ),
                    ListTile(
                      enabled: visibleFloatingWindow && useCustomColor,
                      title: Text(l10n.overlay_window_custom_background_color),
                      leading: const Icon(Icons.color_lens_outlined),
                      trailing: Builder(
                        builder: (context) {
                          final color = context.select<PreferenceBloc, int>(
                            (bloc) => bloc.state.backgroundColor,
                          );

                          return ColoredBox(
                            color: Color(
                              color,
                            ).withTransparency(useCustomColor ? 1 : 0.5),
                            child: const SizedBox(width: 24, height: 24),
                          );
                        },
                      ),
                      onTap: () => showDialog(
                        builder: (dialogCtx) => BlocProvider.value(
                          value: context.read<PreferenceBloc>(),
                          child: AlertDialog(
                            title: Text(l10n.overlay_window_pick_a_color),
                            content: SingleChildScrollView(
                              child: Builder(
                                builder: (context) {
                                  final color = context
                                      .select<PreferenceBloc, int>(
                                        (bloc) => bloc.state.backgroundColor,
                                      );

                                  return ColorPicker(
                                    pickerColor: Color(color),
                                    onColorChanged: (value) => context
                                        .read<PreferenceBloc>()
                                        .add(BackgroundColorUpdated(value)),
                                    paletteType: PaletteType.hueWheel,
                                    hexInputBar: true,
                                  );
                                },
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () => Navigator.of(dialogCtx).pop(),
                                child: Text(l10n.overlay_window_got_it),
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
                          final opacity = context
                              .select<PreferenceBloc, double>(
                                (bloc) => bloc.state.opacity,
                              );

                          return Text('${opacity.toInt()}%');
                        },
                      ),
                      title: Text(l10n.overlay_window_opacity),
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
                              ? (o) => context.read<PreferenceBloc>().add(
                                  OpacityUpdated(o),
                                )
                              : null,
                        );
                      },
                    ),
                    ListTile(
                      enabled: visibleFloatingWindow,
                      leading: const Icon(Icons.font_download_outlined),
                      trailing: Builder(
                        builder: (ctx) => Text(
                          ctx.select((PreferenceBloc b) => b.state.fontFamily),
                        ),
                      ),
                      title: Text(l10n.overlay_window_font_family),
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
                      title: Text(l10n.overlay_window_lyrics_font_size),
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
                              ? (value) => context.read<PreferenceBloc>().add(
                                  FontSizeUpdated(value.toInt()),
                                )
                              : null,
                        );
                      },
                    ),
                    ListTile(
                      enabled: visibleFloatingWindow && useCustomColor,
                      title: Text(l10n.overlay_window_custom_text_color),
                      leading: const Icon(Icons.color_lens_outlined),
                      trailing: Builder(
                        builder: (context) {
                          final color = context.select<PreferenceBloc, int>(
                            (bloc) => bloc.state.color,
                          );

                          return ColoredBox(
                            color: Color(
                              color,
                            ).withTransparency(useCustomColor ? 1 : 0.5),
                            child: const SizedBox(width: 24, height: 24),
                          );
                        },
                      ),
                      onTap: () => showDialog(
                        builder: (dialogCtx) => BlocProvider.value(
                          value: context.read<PreferenceBloc>(),
                          child: AlertDialog(
                            title: Text(l10n.overlay_window_pick_a_color),
                            content: SingleChildScrollView(
                              child: Builder(
                                builder: (context) {
                                  final color = context
                                      .select<PreferenceBloc, int>(
                                        (bloc) => bloc.state.color,
                                      );

                                  return ColorPicker(
                                    pickerColor: Color(color),
                                    onColorChanged: (value) => context
                                        .read<PreferenceBloc>()
                                        .add(ColorUpdated(value)),
                                    paletteType: PaletteType.hueWheel,
                                    hexInputBar: true,
                                  );
                                },
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () => Navigator.of(dialogCtx).pop(),
                                child: Text(l10n.overlay_window_got_it),
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
                title: Text(
                  l10n.overlay_window_element_visibilities_title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
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

                        final title = Text(
                          showMillis
                              ? l10n.overlay_window_show_milliseconds
                              : l10n.overlay_window_hide_milliseconds,
                        );
                        const secondary = Icon(Icons.timelapse_outlined);

                        return ToggleableSwitchListTile(
                          enabled: visibleFloatingWindow,
                          value: showMillis,
                          title: title,
                          secondary: secondary,
                          onChanged: (value) => context
                              .read<PreferenceBloc>()
                              .add(const ShowMillisecondsToggled()),
                        );
                      },
                    ),
                    Builder(
                      builder: (context) {
                        final showBar = context.select<PreferenceBloc, bool>(
                          (bloc) => bloc.state.showProgressBar,
                        );

                        final title = Text(
                          showBar
                              ? l10n.overlay_window_show_progress_bar
                              : l10n.overlay_window_hide_progress_bar,
                        );
                        const secondary = Icon(Icons.linear_scale_outlined);

                        return ToggleableSwitchListTile(
                          enabled: visibleFloatingWindow,
                          value: showBar,
                          title: title,
                          secondary: secondary,
                          onChanged: (value) => context
                              .read<PreferenceBloc>()
                              .add(const ShowProgressBarToggled()),
                        );
                      },
                    ),

                    Builder(
                      builder: (context) {
                        final transparentNotFoundTxt = context
                            .select<PreferenceBloc, bool>(
                              (value) => value.state.transparentNotFoundTxt,
                            );

                        const secondary = Icon(Icons.lyrics_outlined);
                        final prefix = transparentNotFoundTxt ? 'Hide' : 'Show';
                        return ToggleableSwitchListTile(
                          enabled: visibleFloatingWindow,
                          value: transparentNotFoundTxt,
                          title: Text(
                            l10n.overlay_window_hide_no_lyrics_found_text
                                .replaceAll('Hide', prefix)
                                .replaceAll('Show', prefix),
                          ),
                          subtitle: Text(
                            l10n.overlay_window_no_lyrics_found_subtitle,
                          ),
                          secondary: secondary,
                          onChanged: (value) => context
                              .read<PreferenceBloc>()
                              .add(TransparentNotFoundTxtToggled(value)),
                        );
                      },
                    ),

                    Builder(
                      builder: (context) {
                        final showLine2 = context.select<PreferenceBloc, bool>(
                          (bloc) => bloc.state.showLine2,
                        );

                        final title = Text(
                          showLine2
                              ? l10n.overlay_window_show_line_2
                              : l10n.overlay_window_hide_line_2,
                        );
                        const secondary = Icon(Icons.linear_scale_outlined);

                        return ToggleableSwitchListTile(
                          enabled: visibleFloatingWindow,
                          value: showLine2,
                          title: title,
                          secondary: secondary,
                          onChanged: (value) => context
                              .read<PreferenceBloc>()
                              .add(const ShowLine2Toggled()),
                        );
                      },
                    ),

                    Builder(
                      builder: (context) {
                        final enableAnimation = context
                            .select<PreferenceBloc, bool>(
                              (bloc) => bloc.state.enableAnimation,
                            );

                        final title = Text(
                          enableAnimation
                              ? l10n.overlay_window_enable_animation
                              : l10n.overlay_window_disable_animation,
                        );
                        const secondary = Icon(Icons.animation_outlined);

                        return ToggleableSwitchListTile(
                          enabled: visibleFloatingWindow,
                          value: enableAnimation,
                          title: title,
                          secondary: secondary,
                          onChanged: (value) => context
                              .read<PreferenceBloc>()
                              .add(const EnableAnimationToggled()),
                        );
                      },
                    ),

                    Builder(
                      builder: (context) {
                        final animationMode = context
                            .select<PreferenceBloc, AnimationMode>(
                              (bloc) => bloc.state.animationMode,
                            );

                        final enableAnimation = context
                            .select<PreferenceBloc, bool>(
                              (bloc) => bloc.state.enableAnimation,
                            );

                        return SegmentedButton(
                          selected: {animationMode},
                          segments: [
                            for (final mode in AnimationMode.values)
                              ButtonSegment(
                                value: mode,
                                label: Text(mode.label(l10n)),
                              ),
                          ],
                          showSelectedIcon: false,
                          onSelectionChanged:
                              !visibleFloatingWindow || !enableAnimation
                              ? null
                              : (Set<AnimationMode> selections) =>
                                    context.read<PreferenceBloc>().add(
                                      AnimationModeUpdated(selections.first),
                                    ),
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
                      title: Text(l10n.overlay_window_tolerance_title),
                      subtitle: Text(l10n.overlay_window_tolerance_subtitle),
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
                              ? (o) => context.read<PreferenceBloc>().add(
                                  ToleranceUpdated(o.toInt()),
                                )
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
                title: Text(
                  l10n.overlay_window_special_settings_title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: const Icon(Icons.settings_suggest_outlined),
                selected: isExpanded,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Builder(
                      builder: (context) {
                        final isIgnoreTouch = context
                            .select<OverlayWindowSettingsBloc, bool>(
                              (bloc) =>
                                  bloc.state.settings.ignoreTouch ?? false,
                            );
                        return SwitchListTile(
                          value: isIgnoreTouch,
                          title: Text(l10n.overlay_window_ignore_touch_title),
                          subtitle: Text(
                            '${l10n.overlay_window_ignore_touch_subtitle_line1}\n'
                            '${l10n.overlay_window_ignore_touch_subtitle_line2}',
                          ),
                          secondary: const Icon(
                            Icons.warning,
                            color: Colors.orange,
                          ),
                          onChanged: !visibleFloatingWindow
                              ? null
                              : (value) => context
                                    .read<OverlayWindowSettingsBloc>()
                                    .add(WindowIgnoreTouchToggled(value)),
                        );
                      },
                    ),
                    Builder(
                      builder: (context) {
                        final isTouchThru = context
                            .select<OverlayWindowSettingsBloc, bool>(
                              (bloc) => bloc.state.settings.touchThru ?? false,
                            );
                        return SwitchListTile(
                          value: isTouchThru,
                          secondary: const Icon(
                            Icons.warning,
                            color: Colors.red,
                          ),
                          title: Text(l10n.overlay_window_touch_through_title),
                          subtitle: Text(
                            '${l10n.overlay_window_touch_through_subtitle_line1}\n'
                            '${l10n.overlay_window_touch_through_subtitle_line2}',
                          ),
                          onChanged: visibleFloatingWindow
                              ? (value) => context
                                    .read<OverlayWindowSettingsBloc>()
                                    .add(WindowTouchThruToggled(value))
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
    this.subtitle,
    required this.secondary,
    required this.onChanged,
  });

  final bool enabled;
  final bool value;
  final Widget title;
  final Widget secondary;
  final Widget? subtitle;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return enabled
        ? SwitchListTile(
            value: value,
            title: title,
            subtitle: subtitle,
            secondary: secondary,
            onChanged: onChanged,
          )
        : ListTile(
            enabled: false,
            leading: secondary,
            title: title,
            subtitle: subtitle,
            trailing: Switch(value: value, onChanged: null),
          );
  }
}

part of '../page.dart';

class _WindowConfigTab extends StatelessWidget {
  const _WindowConfigTab();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final isWindowVisible = context.select(
      (OverlayWindowSettingsBloc bloc) => bloc.state.isWindowVisible,
    );

    final useAppColor = context.select(
      (PreferenceBloc b) => b.state.useAppColor,
    );
    final useCustomColor = !useAppColor;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.read<OverlayWindowSettingsBloc>().add(
          OverlayWindowSettingsEvent.windowVisibilityToggled(!isWindowVisible),
        ),
        icon: switch (isWindowVisible) {
          true => const Icon(Icons.hide_source),
          false => const Icon(Icons.play_arrow_outlined),
        },
        label: switch (isWindowVisible) {
          true => Text(l10n.overlay_window_hide),
          false => Text(l10n.overlay_window_show),
        },
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
                      onChanged: switch (isWindowVisible) {
                        true => (value) => context.read<PreferenceBloc>().add(
                          PreferenceEvent.windowColorThemeToggled(value),
                        ),
                        false => null,
                      },
                    ),
                    ListTile(
                      enabled: isWindowVisible && useCustomColor,
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
                      onTap: () => _showBackgroundColorPicker(context),
                    ),
                    ListTile(
                      enabled: isWindowVisible,
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
                          onChanged: isWindowVisible
                              ? (o) => context.read<PreferenceBloc>().add(
                                  PreferenceEvent.opacityUpdated(o),
                                )
                              : null,
                        );
                      },
                    ),
                    ListTile(
                      enabled: isWindowVisible,
                      leading: const Icon(Icons.font_download_outlined),
                      trailing: Builder(
                        builder: (ctx) => Text(
                          ctx.select((PreferenceBloc b) => b.state.fontFamily),
                        ),
                      ),
                      title: Text(l10n.overlay_window_font_family),
                      onTap: () => context.goNamed(MainAppRoutes.fonts.name),
                    ),
                    ListTile(
                      enabled: isWindowVisible,
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
                          onChanged: switch (isWindowVisible) {
                            true => (v) => context.read<PreferenceBloc>().add(
                              PreferenceEvent.fontSizeUpdated(v),
                            ),
                            false => null,
                          },
                        );
                      },
                    ),
                    ListTile(
                      enabled: isWindowVisible && useCustomColor,
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
                      onTap: () => _showTextColorPicker(context),
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
                          enabled: isWindowVisible,
                          value: showMillis,
                          title: title,
                          secondary: secondary,
                          onChanged: (value) =>
                              context.read<PreferenceBloc>().add(
                                PreferenceEvent.showMillisecondsToggled(value),
                              ),
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
                          enabled: isWindowVisible,
                          value: showBar,
                          title: title,
                          secondary: secondary,
                          onChanged: (value) =>
                              context.read<PreferenceBloc>().add(
                                PreferenceEvent.showProgressBarToggled(value),
                              ),
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
                        // TODO(Felix): Migrate to l10n with placeholders
                        final prefix = transparentNotFoundTxt ? 'Hide' : 'Show';
                        return ToggleableSwitchListTile(
                          enabled: isWindowVisible,
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
                          onChanged: (value) =>
                              context.read<PreferenceBloc>().add(
                                PreferenceEvent.transparentNotFoundTxtToggled(
                                  value,
                                ),
                              ),
                        );
                      },
                    ),

                    Builder(
                      builder: (context) {
                        final visibleLinesCount = context
                            .select<PreferenceBloc, int>(
                              (bloc) => bloc.state.visibleLinesCount,
                            );

                        return ListTile(
                          enabled: isWindowVisible,
                          leading: const Icon(Icons.view_headline_outlined),
                          trailing: Text('$visibleLinesCount'),
                          title: Text(l10n.overlay_window_visible_lines_count),
                        );
                      },
                    ),

                    Builder(
                      builder: (context) {
                        final visibleLinesCount = context
                            .select<PreferenceBloc, int>(
                              (bloc) => bloc.state.visibleLinesCount,
                            );

                        return Slider(
                          min: 1,
                          max: 10,
                          divisions: 9,
                          value: visibleLinesCount.toDouble(),
                          label: '$visibleLinesCount',
                          onChanged: isWindowVisible
                              ? (value) => context.read<PreferenceBloc>().add(
                                  PreferenceEvent.visibleLinesCountUpdated(
                                    value.toInt(),
                                  ),
                                )
                              : null,
                        );
                      },
                    ),

                    ListTile(
                      enabled: isWindowVisible,
                      leading: const Icon(Icons.hourglass_top_outlined),
                      title: Text(l10n.overlay_window_tolerance_title),
                      subtitle: Text(l10n.overlay_window_tolerance_subtitle),
                    ),
                    Builder(
                      builder: (context) {
                        final tolerance = context.select<PreferenceBloc, int>(
                          (bloc) => bloc.state.tolerance,
                        );
                        return Column(
                          children: [
                            Row(
                              children: [
                                _ToleranceButton(
                                  icon: Icons.remove,
                                  enabled: isWindowVisible,
                                  onChanged: (delta) =>
                                      context.read<PreferenceBloc>().add(
                                        PreferenceEvent.toleranceUpdated(
                                          tolerance - delta,
                                        ),
                                      ),
                                ),
                                Expanded(
                                  child: Slider(
                                    min: -5000,
                                    max: 5000,
                                    divisions: 500,
                                    value: tolerance.toDouble().clamp(
                                      -5000,
                                      5000,
                                    ),
                                    label: '$tolerance ms',
                                    onChanged: switch (isWindowVisible) {
                                      true =>
                                        (v) =>
                                            context.read<PreferenceBloc>().add(
                                              PreferenceEvent.toleranceUpdated(
                                                v.toInt(),
                                              ),
                                            ),
                                      false => null,
                                    },
                                  ),
                                ),
                                _ToleranceButton(
                                  icon: Icons.add,
                                  enabled: isWindowVisible,
                                  onChanged: (delta) =>
                                      context.read<PreferenceBloc>().add(
                                        PreferenceEvent.toleranceUpdated(
                                          tolerance + delta,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: _ToleranceTextField(
                                initialValue: tolerance,
                                enabled: isWindowVisible,
                                onSubmitted: (value) {
                                  if (value != null) {
                                    context.read<PreferenceBloc>().add(
                                      PreferenceEvent.toleranceUpdated(value),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
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
                              (bloc) => bloc.state.config.ignoreTouch ?? false,
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
                          onChanged: switch (isWindowVisible) {
                            true => (value) => _onWindowIgnoreTouchToggled(
                              context,
                              value,
                            ),
                            false => null,
                          },
                        );
                      },
                    ),
                    Builder(
                      builder: (context) {
                        final isTouchThru = context
                            .select<OverlayWindowSettingsBloc, bool>(
                              (bloc) => bloc.state.config.touchThru ?? false,
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
                          onChanged: switch (isWindowVisible) {
                            true => (value) => _onWIndowTouchThruToggled(
                              context,
                              value,
                            ),
                            false => null,
                          },
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

  void _onWIndowTouchThruToggled(BuildContext context, bool value) => context
      .read<OverlayWindowSettingsBloc>()
      .add(OverlayWindowSettingsEvent.windowTouchThroughToggled(value));

  void _onWindowIgnoreTouchToggled(BuildContext context, bool value) => context
      .read<OverlayWindowSettingsBloc>()
      .add(OverlayWindowSettingsEvent.windowIgnoreTouchToggled(value));

  void _showTextColorPicker(BuildContext context) {
    final l10n = context.l10n;

    showDialog(
      builder: (dialogCtx) => BlocProvider.value(
        value: context.read<PreferenceBloc>(),
        child: AlertDialog(
          title: Text(l10n.overlay_window_pick_a_color),
          content: SingleChildScrollView(
            child: Builder(
              builder: (context) {
                final color = context.select<PreferenceBloc, int>(
                  (bloc) => bloc.state.color,
                );

                return ColorPicker(
                  pickerColor: Color(color),
                  onColorChanged: (value) => context.read<PreferenceBloc>().add(
                    PreferenceEvent.colorUpdated(value.toARGB32()),
                  ),
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
    );
  }

  void _showBackgroundColorPicker(BuildContext context) {
    final l10n = context.l10n;

    showDialog(
      context: context,
      builder: (dialogCtx) => BlocProvider.value(
        value: context.read<PreferenceBloc>(),
        child: AlertDialog(
          title: Text(l10n.overlay_window_pick_a_color),
          content: SingleChildScrollView(
            child: Builder(
              builder: (context) {
                final color = context.select<PreferenceBloc, int>(
                  (bloc) => bloc.state.backgroundColor,
                );

                return ColorPicker(
                  pickerColor: Color(color),
                  onColorChanged: (c) => context.read<PreferenceBloc>().add(
                    PreferenceEvent.backgroundColorUpdated(c.toARGB32()),
                  ),
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
    );
  }
}

class ToggleableSwitchListTile extends StatelessWidget {
  const ToggleableSwitchListTile({
    required this.enabled,
    required this.value,
    required this.title,
    required this.secondary,
    required this.onChanged,
    super.key,
    this.subtitle,
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

class _ToleranceButton extends StatefulWidget {
  const _ToleranceButton({
    required this.icon,
    required this.enabled,
    required this.onChanged,
  });

  final IconData icon;
  final bool enabled;
  final void Function(int delta) onChanged;

  @override
  State<_ToleranceButton> createState() => _ToleranceButtonState();
}

class _ToleranceButtonState extends State<_ToleranceButton> {
  Timer? _timer;

  var _pressDuration = 0;

  void _startLongPress() {
    _pressDuration = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      _pressDuration += 100;

      // Accelerating step size based on press duration
      final step = switch (_pressDuration) {
        < 500 => 10,
        < 1000 => 25,
        < 2000 => 50,
        _ => 100,
      };

      widget.onChanged(step);
    });
  }

  void _stopLongPress() {
    _timer?.cancel();
    _timer = null;
    _pressDuration = 0;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return GestureDetector(
      onTap: widget.enabled ? () => widget.onChanged(10) : null,
      onLongPressStart: widget.enabled ? (_) => _startLongPress() : null,
      onLongPressEnd: widget.enabled ? (_) => _stopLongPress() : null,
      onLongPressCancel: widget.enabled ? () => _stopLongPress() : null,
      child: IconButton.outlined(
        icon: Icon(widget.icon),
        onPressed: null, // Handled by GestureDetector
        disabledColor: widget.enabled ? colorScheme.primary : null,
      ),
    );
  }
}

class _ToleranceTextField extends StatefulWidget {
  const _ToleranceTextField({
    required this.initialValue,
    required this.enabled,
    required this.onSubmitted,
  });

  final int initialValue;
  final bool enabled;
  final void Function(int?) onSubmitted;

  @override
  State<_ToleranceTextField> createState() => _ToleranceTextFieldState();
}

class _ToleranceTextFieldState extends State<_ToleranceTextField> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  void didUpdateWidget(_ToleranceTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _controller.text = widget.initialValue.toString();
      _errorText = null;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    final text = _controller.text.trim();
    final value = int.tryParse(text);

    if (text.isEmpty) {
      setState(() => _errorText = 'Please enter a value');
      return;
    }

    if (value == null) {
      setState(() => _errorText = 'Invalid number');
      return;
    }

    if (value < -10000 || value > 10000) {
      setState(() => _errorText = 'Value must be between -10000 and 10000');
      return;
    }

    setState(() => _errorText = null);
    widget.onSubmitted(value);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      enabled: widget.enabled,
      keyboardType: const TextInputType.numberWithOptions(signed: true),
      decoration: InputDecoration(
        labelText: 'Custom tolerance',
        hintText: 'Enter value in ms',
        errorText: _errorText,
        suffixIcon: IconButton(
          icon: const Icon(Icons.check),
          onPressed: widget.enabled ? _validateAndSubmit : null,
          tooltip: 'Apply',
        ),
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      onSubmitted: widget.enabled ? (_) => _validateAndSubmit() : null,
    );
  }
}

part of '../page.dart';

class _WindowConfigTab extends StatelessWidget {
  const _WindowConfigTab();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final pref = MainAppDependency.of(context).watch<PreferenceBloc>().state;
    final windowState = MainAppDependency.of(
      context,
    ).watch<OverlayWindowSettingsBloc>().state;

    final windowConfig = windowState.config;
    final isWindowVisible = windowState.isWindowVisible;

    final useAppColor = pref.useAppColor;
    final useCustomColor = !useAppColor;
    final backgroundColor = pref.backgroundColor;
    final textColor = pref.color;
    final opacity = pref.opacity;
    final fontFamily = pref.fontFamily;
    final fontSize = pref.fontSize;
    final showMillis = pref.showMilliseconds;
    final showProgressBar = pref.showProgressBar;
    final transparentNotFoundTxt = pref.transparentNotFoundTxt;
    final visibleLinesCount = pref.visibleLinesCount;
    final tolerance = pref.tolerance;
    final isIgnoreTouch = pref.windowIgnoreTouch;

    final isTouchThru = windowConfig.touchThru ?? false;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            MainAppDependency.of(context).read<OverlayWindowSettingsBloc>().add(
              OverlayWindowSettingsEvent.windowVisibilityToggled(
                !isWindowVisible,
              ),
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
                        true => (value) => _onUseAppColor(context, value),
                        false => null,
                      },
                    ),

                    ListTile(
                      enabled: isWindowVisible && useCustomColor,
                      title: Text(l10n.overlay_window_custom_background_color),
                      leading: const Icon(Icons.color_lens_outlined),
                      trailing: ColoredBox(
                        color: Color(
                          backgroundColor,
                        ).withTransparency(useCustomColor ? 1 : 0.5),
                        child: const SizedBox(width: 24, height: 24),
                      ),
                      onTap: () => _showBackgroundColorPicker(context),
                    ),

                    ListTile(
                      enabled: isWindowVisible,
                      leading: const Icon(Icons.opacity_outlined),
                      trailing: Text('${opacity.toInt()}%'),
                      title: Text(l10n.overlay_window_opacity),
                    ),

                    Slider(
                      max: 100,
                      divisions: 20,
                      value: opacity,
                      label: '${opacity.toInt()}%',
                      onChanged: isWindowVisible
                          ? (o) => context.read<PreferenceBloc>().add(
                              PreferenceEvent.opacityUpdated(o),
                            )
                          : null,
                    ),

                    ListTile(
                      enabled: isWindowVisible,
                      leading: const Icon(Icons.font_download_outlined),
                      trailing: Text(fontFamily),
                      title: Text(l10n.overlay_window_font_family),
                      onTap: () => context.goNamed(MainAppRoutes.fonts.name),
                    ),

                    ListTile(
                      enabled: isWindowVisible,
                      leading: const Icon(Icons.format_size_outlined),
                      trailing: Text('$fontSize'),
                      title: Text(l10n.overlay_window_lyrics_font_size),
                    ),

                    Slider(
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
                    ),

                    ListTile(
                      enabled: isWindowVisible && useCustomColor,
                      title: Text(l10n.overlay_window_custom_text_color),
                      leading: const Icon(Icons.color_lens_outlined),
                      trailing: ColoredBox(
                        color: Color(
                          textColor,
                        ).withTransparency(useCustomColor ? 1 : 0.5),
                        child: const SizedBox(width: 24, height: 24),
                      ),
                      onTap: () => _showTextColorPicker(context),
                    ),

                    ListTile(
                      enabled: isWindowVisible,
                      title: Text(l10n.overlay_window_text_alignment),
                      leading: const Icon(Icons.format_align_center_outlined),
                      trailing: Text(
                        _getAlignmentLabel(pref.lyricAlignment, l10n),
                      ),
                      onTap: () => _showAlignmentPicker(context),
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
                    _ToggleableSwitchListTile(
                      enabled: isWindowVisible,
                      value: showMillis,
                      title: Text(switch (showMillis) {
                        true => l10n.overlay_window_show_milliseconds,
                        false => l10n.overlay_window_hide_milliseconds,
                      }),
                      secondary: const Icon(Icons.timelapse_outlined),
                      onChanged: (value) => context.read<PreferenceBloc>().add(
                        PreferenceEvent.showMillisecondsToggled(value),
                      ),
                    ),

                    _ToggleableSwitchListTile(
                      enabled: isWindowVisible,
                      value: showProgressBar,
                      title: Text(switch (showProgressBar) {
                        true => l10n.overlay_window_show_progress_bar,
                        false => l10n.overlay_window_hide_progress_bar,
                      }),
                      secondary: const Icon(Icons.linear_scale_outlined),
                      onChanged: (value) => context.read<PreferenceBloc>().add(
                        PreferenceEvent.showProgressBarToggled(value),
                      ),
                    ),

                    _ToggleableSwitchListTile(
                      enabled: isWindowVisible,
                      value: transparentNotFoundTxt,
                      title: Text(switch (transparentNotFoundTxt) {
                        true => l10n.overlay_window_hide_no_lyrics_found_text,
                        false => l10n.overlay_window_show_no_lyrics_found_text,
                      }),
                      subtitle: Text(
                        l10n.overlay_window_no_lyrics_found_subtitle,
                      ),
                      secondary: const Icon(Icons.lyrics_outlined),
                      onChanged: (value) => context.read<PreferenceBloc>().add(
                        PreferenceEvent.transparentNotFoundTxtToggled(value),
                      ),
                    ),

                    ListTile(
                      enabled: isWindowVisible,
                      leading: const Icon(Icons.view_headline_outlined),
                      trailing: Text('$visibleLinesCount'),
                      title: Text(l10n.overlay_window_visible_lines_count),
                    ),

                    Slider(
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
                    ),

                    ListTile(
                      enabled: isWindowVisible,
                      leading: const Icon(Icons.hourglass_top_outlined),
                      title: Text(l10n.overlay_window_tolerance_title),
                      subtitle: Text(l10n.overlay_window_tolerance_subtitle),
                    ),

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
                            value: tolerance.toDouble().clamp(-5000, 5000),
                            label: '$tolerance ms',
                            onChanged: switch (isWindowVisible) {
                              true => (v) => context.read<PreferenceBloc>().add(
                                PreferenceEvent.toleranceUpdated(v.toInt()),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                    SwitchListTile(
                      value: isIgnoreTouch,
                      title: Text(l10n.overlay_window_ignore_touch_title),
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
                    ),

                    SwitchListTile(
                      value: isTouchThru,
                      secondary: const Icon(Icons.warning, color: Colors.red),
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

  void _onUseAppColor(BuildContext context, bool value) => MainAppDependency.of(
    context,
  ).read<PreferenceBloc>().add(PreferenceEvent.windowColorThemeToggled(value));

  void _onWIndowTouchThruToggled(BuildContext context, bool value) =>
      MainAppDependency.of(context).read<OverlayWindowSettingsBloc>().add(
        OverlayWindowSettingsEvent.windowTouchThroughToggled(value),
      );

  void _onWindowIgnoreTouchToggled(BuildContext context, bool value) =>
      MainAppDependency.of(context).read<PreferenceBloc>().add(
        PreferenceEvent.windowIgnoreTouchToggled(value),
      );

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

  String _getAlignmentLabel(LyricAlignment alignment, AppLocalizations l10n) {
    return switch (alignment) {
      LyricAlignment.left => l10n.overlay_window_alignment_left,
      LyricAlignment.center => l10n.overlay_window_alignment_center,
      LyricAlignment.right => l10n.overlay_window_alignment_right,
      LyricAlignment.alternating => l10n.overlay_window_alignment_alternating,
    };
  }

  void _showAlignmentPicker(BuildContext context) {
    final l10n = context.l10n;
    final currentAlignment = MainAppDependency.of(
      context,
    ).read<PreferenceBloc>().state.lyricAlignment;

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l10n.overlay_window_text_alignment),
        content: RadioGroup(
          onChanged: (value) {
            if (value != null) {
              context.read<PreferenceBloc>().add(
                PreferenceEvent.lyricAlignmentUpdated(value),
              );
            }
            Navigator.of(dialogCtx).pop();
          },
          groupValue: currentAlignment,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: LyricAlignment.values
                .map(
                  (alignment) => RadioListTile(
                    title: Text(_getAlignmentLabel(alignment, l10n)),
                    value: alignment,
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(l10n.overlay_window_got_it),
          ),
        ],
      ),
    );
  }
}

class _ToggleableSwitchListTile extends StatelessWidget {
  const _ToggleableSwitchListTile({
    required this.enabled,
    required this.value,
    required this.title,
    required this.secondary,
    required this.onChanged,
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

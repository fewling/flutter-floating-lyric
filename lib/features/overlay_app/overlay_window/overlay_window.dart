import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configs/main_overlay/search_lyric_status.dart';
import '../../../models/overlay_settings_model.dart';
import '../../../utils/extensions/custom_extensions.dart';
import 'bloc/overlay_window_bloc.dart';

class OverlayWindow extends StatelessWidget {
  const OverlayWindow({
    super.key,
    this.onWindowTap,
    this.onCloseTap,
    this.debugText,
    this.isLoading = false,
    required this.settings,
    required this.isLyricOnly,
  });

  final OverlaySettingsModel settings;

  final String? debugText;
  final bool isLyricOnly;
  final bool isLoading;
  final void Function()? onWindowTap;
  final void Function()? onCloseTap;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const OverlayLoadingIndicator();

    final colorScheme = Theme.of(context).colorScheme;
    final foregroundColor = colorScheme.onPrimaryContainer;

    final useAppColor = settings.useAppColor;
    final opacity = (settings.opacity ?? 50) / 100;
    final textColor = (useAppColor ? foregroundColor : Color(settings.color ?? Colors.white.value));

    return Material(
      color: Colors.transparent,
      child: IgnorePointer(
        ignoring: settings.ignoreTouch ?? false,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: useAppColor
                ? colorScheme.primaryContainer.withOpacity(opacity)
                : Color(settings.backgroundColor ?? Colors.black.value).withOpacity(opacity),
          ),
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: onWindowTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (debugText != null)
                    Text(
                      debugText!,
                      style: TextStyle(color: colorScheme.onPrimaryContainer),
                    ),
                  if (!isLyricOnly)
                    OverlayHeader(
                      settings: settings,
                      onCloseTap: onCloseTap,
                      textColor: textColor,
                    ),
                  OverlayContent(
                    settings: settings,
                    textColor: textColor,
                  ),
                  if (!isLyricOnly || (settings.showProgressBar ?? false))
                    OverlayProgressBar(
                      settings: settings,
                      textColor: textColor,
                    ),
                ].separatedBy(const SizedBox(height: 4)).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OverlayContent extends StatelessWidget {
  const OverlayContent({
    super.key,
    required this.settings,
    required this.textColor,
  });

  final OverlaySettingsModel settings;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final line1Pos = settings.line1?.time;
    final line2Pos = settings.line2?.time;

    final line1IsFarther = (line1Pos?.compareTo(line2Pos ?? Duration.zero) ?? 0) > 0;

    final status = settings.searchLyricStatus;
    final showLine2 = settings.showLine2 ?? false;

    switch (status) {
      case SearchLyricStatus.empty:
        return Center(
          child: Text(
            'No lyric',
            style: TextStyle(color: textColor),
          ),
        );
      case SearchLyricStatus.searching:
        return Center(
          child: Text(
            'Searching lyric...',
            style: TextStyle(color: textColor),
          ),
        );
      case SearchLyricStatus.notFound:
        return Center(
          child: Text(
            'Lyric not found',
            style: TextStyle(color: textColor),
          ),
        );
      case SearchLyricStatus.initial:
      case SearchLyricStatus.found:
        return Column(
          children: [
            Align(
              alignment: showLine2 ? Alignment.centerLeft : Alignment.center,
              child: Text(
                settings.line1?.content ?? ' ',
                style: TextStyle(
                  color: textColor,
                  fontSize: settings.fontSize,
                  fontWeight: !line1IsFarther ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (showLine2)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  settings.line2?.content ?? ' ',
                  style: TextStyle(
                    color: textColor,
                    fontSize: settings.fontSize,
                    fontWeight: line1IsFarther ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
          ],
        );
    }
  }
}

class OverlayHeader extends StatelessWidget {
  const OverlayHeader({
    super.key,
    required this.settings,
    required this.onCloseTap,
    required this.textColor,
  });

  final OverlaySettingsModel settings;
  final void Function()? onCloseTap;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            settings.title ?? ' ',
            style: TextStyle(color: textColor),
          ),
        ),
        IconButton(
          onPressed: () =>
              context.read<OverlayWindowBloc>().add(LockToggled(!context.read<OverlayWindowBloc>().state.isLocked)),
          icon: context.select((OverlayWindowBloc b) => b.state.isLocked)
              ? Icon(Icons.lock, color: textColor)
              : Icon(Icons.lock_open_outlined, color: textColor),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.remove, color: textColor),
        ),
        IconButton(
          onPressed: onCloseTap,
          icon: Icon(Icons.close, color: textColor),
        ),
      ],
    );
  }
}

class OverlayProgressBar extends StatelessWidget {
  const OverlayProgressBar({
    super.key,
    required this.settings,
    required this.textColor,
  });

  final OverlaySettingsModel settings;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final pos = Duration(milliseconds: settings.position?.toInt() ?? 0);
    final max = Duration(milliseconds: settings.duration?.toInt() ?? 0);

    final progress = max.inMilliseconds == 0 ? 0 : pos.inMilliseconds / max.inMilliseconds;

    final left = (settings.showMillis ?? false) ? pos.mmssmm() : pos.mmss();
    final right = (settings.showMillis ?? false) ? max.mmssmm() : max.mmss();

    return Row(
      children: [
        Text(
          left,
          style: TextStyle(color: textColor),
        ),
        Expanded(
          child: LinearProgressIndicator(
            value: progress.toDouble(),
            color: textColor,
          ),
        ),
        Text(
          right,
          style: TextStyle(color: textColor),
        ),
      ].separatedBy(const SizedBox(width: 8)).toList(),
    );
  }
}

// TODO(@fewling): Replace with a better loading indicator
class OverlayLoadingIndicator extends StatelessWidget {
  const OverlayLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: CircularProgressIndicator(),
    );
  }
}

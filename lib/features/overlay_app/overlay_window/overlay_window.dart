import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configs/main_overlay/search_lyric_status.dart';
import '../../../models/overlay_settings_model.dart';
import '../../../utils/extensions/custom_extensions.dart';
import '../../message_channels/message_from_main_receiver/bloc/message_from_main_receiver_bloc.dart';
import '../bloc/overlay_app_bloc.dart';
import 'bloc/overlay_window_bloc.dart';

class OverlayWindow extends StatelessWidget {
  const OverlayWindow({
    super.key,
    this.debugText,
    this.isLoading = false,
  });

  final String? debugText;
  final bool isLoading;


  @override
  Widget build(BuildContext context) {
    final settings = context.select(
      (MessageFromMainReceiverBloc bloc) => bloc.state.settings,
    );

    if (settings == null) return const OverlayLoadingIndicator();

    final colorScheme = Theme.of(context).colorScheme;
    final foregroundColor = colorScheme.onPrimaryContainer;

    final useAppColor = settings.useAppColor;
    final opacity = (settings.opacity ?? 50) / 100;
    final textColor = (useAppColor ? foregroundColor : Color(settings.color ?? Colors.white.value));
    final width = context.select((MessageFromMainReceiverBloc b) => b.state.settings?.width);
    final isLyricOnly = context.select((OverlayWindowBloc b) => b.state.isLyricOnly);

    return SizedBox(
      width: width,
      height: double.infinity,
      child: Material(
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
              onTap: () => context.read<OverlayWindowBloc>().add(const WindowTapped()),
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
    required this.textColor,
  });

  final OverlaySettingsModel settings;
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
          onPressed: () => context.read<OverlayAppBloc>().add(const MinimizeRequested()),
          icon: Icon(Icons.remove, color: textColor),
        ),
        IconButton(
          onPressed: () => context.read<OverlayWindowBloc>().add(const CloseRequested()),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: Container(
        height: 200,
        width: 200,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: colorScheme.primaryContainer,
        ),
        margin: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => context.read<OverlayWindowBloc>().add(const CloseRequested()),
                icon: Icon(Icons.close, color: colorScheme.onPrimaryContainer),
              ),
            ),
            Align(
              child: Text(
                'Waiting for music player',
                style: TextStyle(color: colorScheme.onPrimaryContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

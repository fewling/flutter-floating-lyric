import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    // final foregroundColor = settings.color == null ? null : Color(settings.color!);
    final foregroundColor = Theme.of(context).colorScheme.onPrimaryContainer;
    final line1Pos = settings.line1?.time;
    final line2Pos = settings.line2?.time;

    final line1IsFarther = (line1Pos?.compareTo(line2Pos ?? Duration.zero) ?? 0) > 0;

    return Material(
      child: IgnorePointer(
        ignoring: settings.ignoreTouch ?? false,
        child: Card(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: onWindowTap,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (debugText != null)
                    Text(
                      debugText!,
                      style: TextStyle(color: foregroundColor),
                    ),
                  if (!isLyricOnly)
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            settings.title ?? ' ',
                            style: TextStyle(color: foregroundColor),
                          ),
                        ),
                        IconButton(
                          onPressed: () => context
                              .read<OverlayWindowBloc>()
                              .add(LockToggled(!context.read<OverlayWindowBloc>().state.isLocked)),
                          icon: context.select((OverlayWindowBloc b) => b.state.isLocked)
                              ? Icon(Icons.lock, color: foregroundColor)
                              : Icon(Icons.lock_open_outlined, color: foregroundColor),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.remove, color: foregroundColor),
                        ),
                        IconButton(
                          onPressed: onCloseTap,
                          icon: Icon(Icons.close, color: foregroundColor),
                        ),
                      ],
                    ),
                  Align(
                    alignment: (settings.showLine2 ?? false) ? Alignment.centerLeft : Alignment.center,
                    child: Text(
                      settings.line1?.content ?? ' ',
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize: settings.fontSize,
                        fontWeight: !line1IsFarther ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (settings.showLine2 ?? false)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        settings.line2?.content ?? ' ',
                        style: TextStyle(
                          color: foregroundColor,
                          fontSize: settings.fontSize,
                          fontWeight: line1IsFarther ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  if (!isLyricOnly || (settings.showProgressBar ?? false))
                    OverlayProgressBar(
                      settings: settings,
                      foregroundColor: foregroundColor,
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

class OverlayProgressBar extends StatelessWidget {
  const OverlayProgressBar({
    super.key,
    required this.settings,
    required this.foregroundColor,
  });

  final OverlaySettingsModel settings;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = Theme.of(context).colorScheme.onPrimaryContainer;

    final pos = Duration(milliseconds: settings.position?.toInt() ?? 0);
    final max = Duration(milliseconds: settings.duration?.toInt() ?? 0);

    final progress = max.inMilliseconds == 0 ? 0 : pos.inMilliseconds / max.inMilliseconds;

    final left = (settings.showMillis ?? false) ? pos.mmssmm() : pos.mmss();
    final right = (settings.showMillis ?? false) ? max.mmssmm() : max.mmss();

    return Row(
      children: [
        Text(
          left,
          style: TextStyle(color: foregroundColor),
        ),
        Expanded(
          child: LinearProgressIndicator(
            value: progress.toDouble(),
            color: foregroundColor,
          ),
        ),
        Text(
          right,
          style: TextStyle(color: foregroundColor),
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

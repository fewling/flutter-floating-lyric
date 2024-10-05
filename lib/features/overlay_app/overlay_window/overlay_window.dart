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

    return InkWell(
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
                  ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: () => context.read<OverlayWindowBloc>().add(const LockToggled()),
                        child: context.select((OverlayWindowBloc b) => b.state.isLocked)
                            ? Icon(Icons.lock, color: foregroundColor)
                            : Icon(Icons.lock_open_outlined, color: foregroundColor),
                      ),
                    ),
                  ),
                  ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: () {},
                        child: Icon(Icons.remove, color: foregroundColor),
                      ),
                    ),
                  ),
                  ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onCloseTap,
                        child: Icon(Icons.close, color: foregroundColor),
                      ),
                    ),
                  ),
                ].separatedBy(const SizedBox(width: 16)).toList(),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                settings.line1 ?? ' ',
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: settings.fontSize,
                ),
              ),
            ),
            if (settings.showLine2 ?? false)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  settings.line2 ?? ' ',
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: settings.fontSize,
                  ),
                ),
              ),
            if (!isLyricOnly)
              OverlayProgressBar(
                settings: settings,
                foregroundColor: foregroundColor,
              ),
          ].separatedBy(const SizedBox(height: 4)).toList(),
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

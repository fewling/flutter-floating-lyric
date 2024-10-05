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
    if (isLoading) return _OverlayLoadingIndicator(debugText: debugText);

    // final foregroundColor = settings.color == null ? null : Color(settings.color!);
    final foregroundColor = Theme.of(context).colorScheme.onPrimaryContainer;

    final pos = settings.position ?? 0;
    final max = settings.duration ?? 0;

    final progress = max == 0 ? 0 : pos / max;

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
                      settings.title ?? '',
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
                settings.line1 ?? '',
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: settings.fontSize,
                ),
              ),
            ),
            if (settings.line2 != null && settings.line2!.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  settings.line2 ?? '',
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: settings.fontSize,
                  ),
                ),
              ),
            if (!isLyricOnly)
              Row(
                children: [
                  Text(
                    settings.positionLeftLabel ?? '',
                    style: TextStyle(color: foregroundColor),
                  ),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: progress.toDouble(),
                      color: foregroundColor,
                    ),
                  ),
                  Text(
                    settings.positionRightLabel ?? '',
                    style: TextStyle(color: foregroundColor),
                  ),
                ].separatedBy(const SizedBox(width: 8)).toList(),
              )
          ].separatedBy(const SizedBox(height: 4)).toList(),
        ),
      ),
    );
  }
}

// TODO(@fewling): Replace with a better loading indicator
class _OverlayLoadingIndicator extends StatelessWidget {
  const _OverlayLoadingIndicator({
    super.key,
    required this.debugText,
  });

  final String? debugText;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ColoredBox(
        color: Colors.red.shade300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (debugText != null)
              Text(
                debugText!,
                style: const TextStyle(color: Colors.white),
              ),
          ].separatedBy(const SizedBox(height: 8)).toList(),
        ),
      ),
    );
  }
}

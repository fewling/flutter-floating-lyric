import 'package:flutter/material.dart';

import '../features/overlay_app/bloc/overlay_app_bloc.dart';
import '../models/overlay_settings_model.dart';
import '../utils/extensions/custom_extensions.dart';

class OverlayWindow extends StatelessWidget {
  const OverlayWindow({
    super.key,
    this.onWindowTap,
    this.onCloseTap,
    this.debugText,
    this.isLoading = false,
    required this.settings,
    required this.mode,
  });

  final OverlaySettingsModel settings;

  final String? debugText;
  final OverlayMode mode;
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (debugText != null)
              Text(
                debugText!,
                style: TextStyle(color: foregroundColor),
              ),
            if (mode.isFull)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      settings.title ?? '',
                      style: TextStyle(color: foregroundColor),
                    ),
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
            if (mode.isFull)
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

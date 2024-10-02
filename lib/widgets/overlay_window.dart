import 'package:flutter/material.dart';

import '../models/overlay_settings_model.dart';
import '../utils/extensions/custom_extensions.dart';

class OverlayWindow extends StatelessWidget {
  const OverlayWindow({
    super.key,
    this.onCloseTap,
    this.debugText,
    this.isLoading = false,
    required this.settings,
  });

  final OverlaySettingsModel settings;

  final String? debugText;
  final bool isLoading;
  final void Function()? onCloseTap;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? _OverlayLoadingIndicator(debugText: debugText)
        : _OverlayContent(
            debugText: debugText,
            settings: settings,
            onCloseTap: onCloseTap,
          );
  }
}

class _OverlayContent extends StatelessWidget {
  const _OverlayContent({
    super.key,
    required this.settings,
    required this.onCloseTap,
    this.debugText,
  });

  final OverlaySettingsModel settings;

  final String? debugText;
  final void Function()? onCloseTap;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = settings.color == null ? null : Color(settings.color!);

    final showLyricOnly = settings.showLyricOnly ?? false;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (debugText != null)
            Text(
              debugText!,
              style: TextStyle(color: foregroundColor),
            ),
          if (!showLyricOnly)
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
          if (!showLyricOnly)
            Row(
              children: [
                Text(
                  settings.positionLeftLabel ?? '',
                  style: TextStyle(color: foregroundColor),
                ),
                Expanded(
                  child: LinearProgressIndicator(
                    value: settings.position ?? 0,
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

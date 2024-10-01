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
            opacity: settings.opacity?.toInt() ?? 50,
            debugText: debugText,
            // foregroundColor: settings.color == null ? null : Color(settings.color!),
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            title: settings.title,
            onCloseTap: onCloseTap,
            line1: settings.line1,
            lineFontSize: settings.fontSize,
            line2: settings.line2,
            positionLeftLabel: settings.positionLeftLabel,
            position: settings.position,
            positionRightLabel: settings.positionRightLabel,
          );
  }
}

class _OverlayContent extends StatelessWidget {
  const _OverlayContent({
    super.key,
    required this.opacity,
    required this.debugText,
    required this.foregroundColor,
    required this.title,
    required this.onCloseTap,
    required this.line1,
    required this.lineFontSize,
    required this.line2,
    required this.positionLeftLabel,
    required this.position,
    required this.positionRightLabel,
  });

  final int opacity;
  final String? debugText;
  final Color? foregroundColor;
  final String? title;
  final void Function()? onCloseTap;
  final String? line1;
  final double? lineFontSize;
  final String? line2;
  final String? positionLeftLabel;
  final double? position;
  final String? positionRightLabel;

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              Expanded(
                child: Text(
                  title ?? '',
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
              line1 ?? '',
              style: TextStyle(
                color: foregroundColor,
                fontSize: lineFontSize,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              line2 ?? '',
              style: TextStyle(
                color: foregroundColor,
                fontSize: lineFontSize,
              ),
            ),
          ),
          Row(
            children: [
              Text(
                positionLeftLabel ?? '',
                style: TextStyle(color: foregroundColor),
              ),
              Expanded(
                child: LinearProgressIndicator(
                  value: position ?? 0,
                  color: foregroundColor,
                ),
              ),
              Text(
                positionRightLabel ?? '',
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

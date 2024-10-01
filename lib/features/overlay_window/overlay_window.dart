import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import '../../utils/extensions/custom_extensions.dart';
import '../overlay_app/bloc/overlay_app_bloc.dart';
import 'bloc/overlay_window_bloc.dart';

/// Must sync the UI with [OverlayWindowMeasurer]
class OverlayWindow extends StatefulWidget {
  const OverlayWindow({super.key});

  @override
  State<OverlayWindow> createState() => _OverlayWindowState();
}

class _OverlayWindowState extends State<OverlayWindow> {
  String? _debugText;
  OverlayWindowState? _state;

  @override
  Widget build(BuildContext context) {
    final debugText = context.watch<OverlayAppBloc>().state.debugText;

    if (_state == null) {
      // TODO(@fewling): Replace with a better loading indicator
      return Material(
        child: ColoredBox(
          color: Colors.red.shade300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_debugText ?? 'No lyric state'),
              Text(debugText, style: const TextStyle(color: Colors.white)),
            ].separatedBy(const SizedBox(height: 8)).toList(),
          ),
        ),
      );
    }

    // 0 ~ 100
    final opacity = (_state!.settings.opacity ?? 50).toInt();
    final foregroundColor = Color(_state!.settings.color ?? 0);

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(opacity / 100),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Text(
              debugText,
              style: TextStyle(color: foregroundColor),
            ),
            if (_debugText != null)
              Text(
                _debugText!,
                style: TextStyle(color: foregroundColor),
              ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _state?.settings.title ?? '',
                    style: TextStyle(color: foregroundColor),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.remove, color: foregroundColor),
                ),
                IconButton(
                  onPressed: () => FlutterOverlayWindow.closeOverlay(),
                  icon: Icon(Icons.close, color: foregroundColor),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _state?.settings.line1 ?? '',
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: _state?.settings.fontSize,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                _state?.settings.line2 ?? '',
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: _state?.settings.fontSize,
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  _state?.settings.positionLeftLabel ?? '',
                  style: TextStyle(color: foregroundColor),
                ),
                Expanded(
                  child: LinearProgressIndicator(
                    value: _state?.settings.position ?? 0,
                    color: foregroundColor,
                  ),
                ),
                Text(
                  _state?.settings.positionRightLabel ?? '',
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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/extensions/custom_extensions.dart';
import 'bloc/overlay_window_bloc.dart';

/// Must sync the UI with [OverlayWindowMeasurer]
class OverlayWindow extends ConsumerStatefulWidget {
  const OverlayWindow({super.key});

  @override
  ConsumerState<OverlayWindow> createState() => _OverlayWindowState();
}

class _OverlayWindowState extends ConsumerState<OverlayWindow> {
  String? _debugText;
  OverlayWindowState? _state;

  @override
  void initState() {
    super.initState();

    FlutterOverlayWindow.overlayListener.listen((event) {
      setState(() {
        try {
          final json = jsonDecode(event.toString());
          _state = OverlayWindowState.fromJson(json as Map<String, dynamic>);
        } catch (e) {
          _debugText = e.toString();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_state == null) {
      // TODO(@fewling): Replace with a better loading indicator
      return Material(
        child: Container(
          color: Colors.red.shade300,
          child: Center(
            child: Text(_debugText ?? 'No lyric state'),
          ),
        ),
      );
    }

    // 0 ~ 100
    final opacity = (_state!.opacity ?? 50).toInt();
    final foregroundColor = Color(_state!.color ?? 0);

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(opacity / 100),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            if (_debugText != null)
              Text(
                _debugText!,
                style: TextStyle(color: foregroundColor),
              ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _state?.title ?? '',
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
                _state?.line1 ?? '',
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: _state?.fontSize,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                _state?.line2 ?? '',
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: _state?.fontSize,
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  _state?.positionLeftLabel ?? '',
                  style: TextStyle(color: foregroundColor),
                ),
                Expanded(
                  child: LinearProgressIndicator(
                    value: _state?.position ?? 0,
                    color: foregroundColor,
                  ),
                ),
                Text(
                  _state?.positionRightLabel ?? '',
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

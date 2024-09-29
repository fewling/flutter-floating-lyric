import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/extensions/custom_extensions.dart';
import 'floating_overlay_event.dart';
import 'floating_overlay_state_types.dart';
import 'overlay_window_lyric_state.dart';
import 'overlay_window_style_state.dart';

class OverlayWindow extends ConsumerStatefulWidget {
  const OverlayWindow({super.key});

  @override
  ConsumerState<OverlayWindow> createState() => _OverlayWindowState();
}

class _OverlayWindowState extends ConsumerState<OverlayWindow> {
  String? _debugText;
  OverlayWindowLyricState? _lyricState;
  OverlayWindowStyleState? _styleState;

  @override
  void initState() {
    super.initState();

    FlutterOverlayWindow.overlayListener.listen((event) {
      setState(() {
        try {
          final evJson = jsonDecode(event.toString()) as Map<String, dynamic>;
          final ev = FloatingOverlayEvent.fromJson(evJson);

          switch (ev.type) {
            case FloatingOverlayStateTypes.lyricState:
              _lyricState = ev.lyricState;
              break;
            case FloatingOverlayStateTypes.styleState:
              _styleState = ev.styleState;
              break;
          }
        } catch (e) {
          _debugText = e.toString();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_lyricState == null) {
      return Material(
        child: Container(
          color: Colors.red.shade300,
          child: Center(
            child: Text(_debugText ?? 'No lyric state'),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.amber,
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            if (_debugText != null) Text(_debugText!),
            Row(
              children: [
                Expanded(
                  child: Text(_lyricState!.title),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.remove),
                ),
                IconButton(
                  onPressed: () => FlutterOverlayWindow.closeOverlay(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(_lyricState!.line1),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(_lyricState!.line2),
            ),
            Row(
              children: [
                Text(
                  _lyricState!.positionLeftLabel,
                ),
                Expanded(
                  child: LinearProgressIndicator(
                    value: _lyricState!.position,
                  ),
                ),
                Text(
                  _lyricState!.positionRightLabel,
                ),
              ].separatedBy(const SizedBox(width: 8)).toList(),
            )
          ].separatedBy(const SizedBox(height: 8)).toList(),
        ),
      ),
    );
  }
}

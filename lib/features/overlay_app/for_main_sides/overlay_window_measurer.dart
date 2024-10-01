import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/extensions/custom_extensions.dart';
import '../../overlay_window/bloc/overlay_window_bloc.dart';

final overlayWindowMeasureKey = GlobalKey();

/// Must sync the UI with [OverlayWindow]
class OverlayWindowMeasurer extends StatelessWidget {
  const OverlayWindowMeasurer({super.key});

  @override
  Widget build(BuildContext context) {
    final windowSettings = context.watch<OverlayWindowBloc>().state.settings;

    return Padding(
      key: overlayWindowMeasureKey,
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(windowSettings.title ?? 'No title'),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.remove),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              windowSettings.line1 ?? '...',
              style: TextStyle(
                fontSize: windowSettings.fontSize,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              windowSettings.line2 ?? '...',
              style: TextStyle(
                fontSize: windowSettings.fontSize,
              ),
            ),
          ),
          Row(
            children: [
              Text(
                windowSettings.positionLeftLabel ?? '...',
              ),
              Expanded(
                child: LinearProgressIndicator(
                  value: windowSettings.position ?? 0,
                ),
              ),
              Text(
                windowSettings.positionRightLabel ?? '...',
              ),
            ].separatedBy(const SizedBox(width: 8)).toList(),
          )
        ].separatedBy(const SizedBox(height: 4)).toList(),
      ),
    );
  }
}

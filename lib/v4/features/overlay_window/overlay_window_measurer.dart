import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/extensions/custom_extensions.dart';
import 'bloc/overlay_window_bloc.dart';

class OverlayWindowMeasurer extends StatelessWidget {
  const OverlayWindowMeasurer({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OverlayWindowBloc>().state;

    return Scaffold(
      backgroundColor: Colors.amber,
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(state.title ?? 'No title'),
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
              child: Text(state.line1 ?? ''),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(state.line2 ?? ''),
            ),
            Row(
              children: [
                Text(
                  state.positionLeftLabel ?? '',
                ),
                Expanded(
                  child: LinearProgressIndicator(
                    value: state.position ?? 0,
                  ),
                ),
                Text(
                  state.positionRightLabel ?? '',
                ),
              ].separatedBy(const SizedBox(width: 8)).toList(),
            )
          ].separatedBy(const SizedBox(height: 8)).toList(),
        ),
      ),
    );
  }
}

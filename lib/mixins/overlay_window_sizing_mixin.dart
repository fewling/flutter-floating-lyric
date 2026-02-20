import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/overlay_app/overlay_app_bloc.dart';
import '../blocs/overlay_window/overlay_window_bloc.dart';
import '../utils/logger.dart';

mixin OverlayWindowSizingMixin {
  void updateSize(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      final box = context.findRenderObject() as RenderBox?;
      if (box == null) {
        logger.e('Root box is null. Cannot update size.');
        context.read<OverlayWindowBloc>().add(
          const OverlayWindowEvent.windowResized(width: 50, height: 50),
        );
        return;
      }

      final view = View.of(context);
      final pxRatio = view.devicePixelRatio;

      final isMinimized = context.read<OverlayAppBloc>().state.isMinimized;
      final width = isMinimized
          ? 48.0
          : (screenWidth > 0 ? screenWidth : 300.0);
      final height = box.getMaxIntrinsicHeight(width);

      context.read<OverlayWindowBloc>().add(
        OverlayWindowEvent.windowResized(
          width: (width + 0.3) * pxRatio,
          height: (height + 6) * pxRatio,
        ),
      );
    });
  }
}

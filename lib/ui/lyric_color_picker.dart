import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

import '../singletons/window_controller.dart';

class LyricColorPicker extends StatelessWidget {
  const LyricColorPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final windowController = Get.find<WindowController>();

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.colorize_outlined),
        title: const Text('Colour your lyric'),
      ),
      body: LayoutBuilder(
        builder: (context, constraint) => SizedBox(
          width: constraint.maxWidth,
          height: constraint.maxHeight,
          child: Obx(
            () => MaterialPicker(
              pickerColor: windowController.textColor,
              onColorChanged: (color) => windowController.textColor = color,
              enableLabel: true, // only on portrait mode
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ColorPickerSheet extends StatelessWidget {
  const ColorPickerSheet({
    super.key,
    required this.colorValue,
    this.onColorChanged,
  });

  final int colorValue;
  final void Function(Color color)? onColorChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // TODO: make bottom sheet scrollable

    return Column(
      children: [
        // Handle
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 22),
          child: Opacity(
            opacity: 0.4,
            child: Container(
              color: colorScheme.onSurfaceVariant,
              width: 32,
              height: 4,
            ),
          ),
        ),

        // Color Grids
        Expanded(
          child: GridView.builder(
            itemCount: Colors.primaries.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100,
            ),
            itemBuilder: (_, index) {
              final c = Colors.primaries[index % Colors.primaries.length];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Material(
                      color: c,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        onTap: () => onColorChanged?.call(c),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    if (colorValue == c.toARGB32())
                      const Positioned.fill(child: Icon(Icons.check)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

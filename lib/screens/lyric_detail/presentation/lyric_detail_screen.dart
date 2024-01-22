import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'lyric_detail_notifier.dart';

class LyricDetailScreen extends ConsumerWidget {
  const LyricDetailScreen({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialContent = ref.watch(
      lyricDetailNotifierProvider(id: id).select(
        (value) => value.valueOrNull?.originalContent,
      ),
    );

    final currentContent = ref.watch(
      lyricDetailNotifierProvider(id: id).select(
        (value) => value.valueOrNull?.lrcDB?.content,
      ),
    );

    final canPop = initialContent == currentContent;

    return PopScope(
      canPop: canPop,
      onPopInvoked: (_) => canPop
          ? null
          : showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Discard changes?'),
                content: const Text(
                  'Are you sure you want to discard your changes?',
                ),
                actions: [
                  TextButton(
                    onPressed: context.pop,
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () =>
                        Future.delayed(const Duration(milliseconds: 100), () {
                      context.pop();
                      context.pop();
                    }),
                    child: const Text('Discard'),
                  ),
                ],
              ),
            ),
      child: Scaffold(
        appBar: AppBar(
          title: LyricFileNameLabel(id: id),
          actions: [
            if (!canPop) LyricSaveButton(id: id),
          ],
        ),
        body: LyricContentField(id: id),
      ),
    );
  }
}

class LyricSaveButton extends ConsumerWidget {
  const LyricSaveButton({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () => ref
          .read(lyricDetailNotifierProvider(id: id).notifier)
          .save()
          .then((id) => id == -1 ? _showError(context) : _showSuccess(context)),
      icon: const Icon(Icons.save_outlined),
    );
  }

  void _showError(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: colorScheme.onErrorContainer,
            ),
            const SizedBox(width: 8),
            Text(
              'Error saving lyric',
              style: TextStyle(color: colorScheme.onErrorContainer),
            ),
          ],
        ),
        backgroundColor: colorScheme.errorContainer,
        closeIconColor: colorScheme.onErrorContainer,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSuccess(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: colorScheme.primaryContainer,
        closeIconColor: colorScheme.onPrimaryContainer,
        content: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: 8),
            Text(
              'Lyric saved',
              style: TextStyle(color: colorScheme.onPrimaryContainer),
            ),
          ],
        ),
      ),
    );
  }
}

class LyricFileNameLabel extends ConsumerWidget {
  const LyricFileNameLabel({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filename = ref.watch(
      lyricDetailNotifierProvider(id: id).select(
        (value) => value.valueOrNull?.lrcDB?.fileName,
      ),
    );

    return Text(filename ?? '...');
  }
}

class LyricContentField extends StatefulWidget {
  const LyricContentField({
    super.key,
    required this.id,
  });

  final String id;

  @override
  State<LyricContentField> createState() => _LyricContentFieldState();
}

class _LyricContentFieldState extends State<LyricContentField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ref.listen(
          lyricDetailNotifierProvider(id: widget.id),
          (previous, next) {
            if (previous == next) return;
            _controller.text = next.value?.lrcDB?.content ?? '';
          },
        );

        return TextField(
          controller: _controller,
          onChanged: ref
              .read(lyricDetailNotifierProvider(id: widget.id).notifier)
              .updateContent,
          expands: true,
          maxLines: null,
        );
      },
    );
  }
}

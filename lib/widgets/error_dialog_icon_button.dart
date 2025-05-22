import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorDialogIconButton extends StatelessWidget {
  const ErrorDialogIconButton({
    super.key,
    required this.error,
    required this.stackTrace,
  });

  final Object error;
  final StackTrace stackTrace;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final txtTheme = Theme.of(context).textTheme;

    return IconButton(
      color: colorScheme.error,
      onPressed: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: colorScheme.error,
          iconColor: colorScheme.onError,
          titleTextStyle: txtTheme.titleLarge?.copyWith(
            color: colorScheme.onError,
          ),
          contentTextStyle: txtTheme.bodyLarge?.copyWith(
            color: colorScheme.onError,
          ),
          icon: const Icon(Icons.error_outline),
          title: const Text('Something went wrong'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(error.toString()),
                const Divider(),
                SelectableText(stackTrace.toString()),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: context.pop, child: const Text('OK')),
            ElevatedButton(
              onPressed: () {
                // TODO: send to developer button
              },
              child: const Text('Report'),
            ),
          ],
        ),
      ),
      icon: const Icon(Icons.error_outline),
    );
  }
}

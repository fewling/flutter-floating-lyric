import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/extensions/custom_extensions.dart';

class ErrorDialogIconButton extends StatelessWidget {
  const ErrorDialogIconButton({
    required this.error,
    required this.stackTrace,
    super.key,
  });

  final Object error;
  final StackTrace stackTrace;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
          title: Text(l10n.error_dialog_title),
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
            TextButton(
              onPressed: context.pop,
              child: Text(l10n.error_dialog_ok),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: send to developer button
              },
              child: Text(l10n.error_dialog_report),
            ),
          ],
        ),
      ),
      icon: const Icon(Icons.error_outline),
    );
  }
}

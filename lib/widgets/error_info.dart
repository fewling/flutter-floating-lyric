import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'error_dialog_icon_button.dart';

class ErrorInfo extends StatelessWidget {
  const ErrorInfo({super.key, required this.error, required this.stackTrace});

  final Object error;
  final StackTrace stackTrace;

  @override
  Widget build(BuildContext context) {
    return kDebugMode
        ? ListView(
            children: [
              SelectableText(error.toString()),
              const Divider(),
              SelectableText(stackTrace.toString()),
            ],
          )
        : Center(
            child: ErrorDialogIconButton(error: error, stackTrace: stackTrace),
          );
  }
}

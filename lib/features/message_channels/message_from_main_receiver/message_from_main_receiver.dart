import 'package:flutter/material.dart';

class MessageFromMainReceiver extends StatelessWidget {
  const MessageFromMainReceiver({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

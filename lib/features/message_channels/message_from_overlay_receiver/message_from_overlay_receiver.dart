import 'package:flutter/material.dart';

class MessageFromOverlayReceiver extends StatelessWidget {
  const MessageFromOverlayReceiver({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

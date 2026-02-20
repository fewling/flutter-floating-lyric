import 'package:flutter/material.dart';

part '_dependency.dart';
part '_listener.dart';
part '_view.dart';

class BaseShell extends StatelessWidget {
  const BaseShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _Dependency(
      builder: (context) =>
          _Listener(builder: (context) => _View(child: child)),
    );
  }
}

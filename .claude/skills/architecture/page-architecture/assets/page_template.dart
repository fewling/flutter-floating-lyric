import 'package:flutter/widgets.dart';

part '_dependency.dart';
part '_listener.dart';
part '_view.dart';

class {{PageName}}Page extends StatelessWidget {
  const {{PageName}}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return _Dependency(
      builder: (context) => _Listener(
        builder: (context) => const _View(),
      ),
    );
  }
}

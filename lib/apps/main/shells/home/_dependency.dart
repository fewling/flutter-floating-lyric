part of 'shell.dart';

class _Dependency extends StatelessWidget {
  const _Dependency({required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: builder);
  }
}

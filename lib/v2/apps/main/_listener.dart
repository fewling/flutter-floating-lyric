part of 'main_app.dart';

class MainAppListener extends StatelessWidget {
  const MainAppListener({required this.builder, super.key});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: builder);
  }
}

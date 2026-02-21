part of 'page.dart';

class _Dependency extends StatelessWidget {
  const _Dependency({required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    // TODO: Add providers, repositories, BLoCs here
    // Example with BlocProvider:
    // return BlocProvider(
    //   create: (context) => {{PageName}}Bloc(
    //     repository: context.read<Repository>(),
    //   ),
    //   child: Builder(builder: builder),
    // );

    return Builder(builder: builder);
  }
}

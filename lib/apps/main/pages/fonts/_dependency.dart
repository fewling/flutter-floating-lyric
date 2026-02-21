part of 'page.dart';

class _Dependency extends StatelessWidget {
  const _Dependency({required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              FontSelectionBloc()..add(const FontSelectionEvent.started()),
        ),
      ],
      child: Builder(builder: builder),
    );
  }
}

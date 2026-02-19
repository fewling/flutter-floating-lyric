part of 'page.dart';

class _Dependency extends StatelessWidget {
  const _Dependency({required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LyricListBloc(
            localDbService: MainAppDependency.of(
              context,
            ).read<LocalDbService>(),
            lrcProcessorService: MainAppDependency.of(
              context,
            ).read<LrcProcessorService>(),
          )..add(const LyricListEvent.started()),
        ),
      ],
      child: Builder(builder: builder),
    );
  }
}

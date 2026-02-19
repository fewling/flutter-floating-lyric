part of 'page.dart';

class _Dependency extends StatelessWidget {
  const _Dependency({required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LyricFinderBloc(
            localDbService: OverlayAppDependency.of(
              context,
            ).read<LocalDbService>(),

            lyricRepository: OverlayAppDependency.of(
              context,
            ).read<LrcLibRepository>(),
          ),
        ),
      ],
      child: Builder(builder: builder),
    );
  }
}

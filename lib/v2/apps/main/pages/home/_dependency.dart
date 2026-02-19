part of 'page.dart';

class _Dependency extends StatelessWidget {
  const _Dependency({required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StartMusicAppBloc(
            methodChannelService: MainAppDependency.of(
              context,
            ).read<MethodChannelService>(),
          ),
        ),
        BlocProvider(
          create: (context) => ImportLocalLrcBloc(
            lrcProcessorService: MainAppDependency.of(
              context,
            ).read<LrcProcessorService>(),
          )..add(const ImportLocalLrcEvent.started()),
        ),
      ],
      child: Builder(builder: builder),
    );
  }
}

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
          create: (context) => LocalLrcPickerBloc(
            lrcProcessorService: MainAppDependency.of(
              context,
            ).read<LrcProcessorService>(),
          ),
        ),

        BlocProvider(
          create: (context) =>
              FetchOnlineLrcFormBloc(
                lrcLibRepo: MainAppDependency.of(
                  context,
                ).read<LrcLibRepository>(),
              )..add(
                FetchOnlineLrcFormStarted(
                  album: context
                      .read<MediaListenerBloc>()
                      .state
                      .activeMediaState
                      ?.album,
                  artist: context
                      .read<MediaListenerBloc>()
                      .state
                      .activeMediaState
                      ?.artist,
                  title: context
                      .read<MediaListenerBloc>()
                      .state
                      .activeMediaState
                      ?.title,
                  duration: context
                      .read<MediaListenerBloc>()
                      .state
                      .activeMediaState
                      ?.duration,
                ),
              ),
        ),
      ],
      child: Builder(builder: builder),
    );
  }
}

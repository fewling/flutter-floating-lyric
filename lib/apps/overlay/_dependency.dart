part of 'overlay_app.dart';

class OverlayAppDependency extends StatefulWidget {
  const OverlayAppDependency({required this.builder, super.key});

  final Widget Function(BuildContext context, AppRouter appRouter) builder;

  static BuildContext of(BuildContext context) => context;

  @override
  State<OverlayAppDependency> createState() => _OverlayAppDependencyState();
}

class _OverlayAppDependencyState extends State<OverlayAppDependency> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter.overlay();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => ToMainMsgService()),
        RepositoryProvider(create: (context) => LayoutChannelService()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                OverlayAppBloc()..add(const OverlayAppEvent.started()),
          ),

          BlocProvider(
            lazy: false,
            create: (context) =>
                MsgFromMainBloc()..add(const MsgFromMainEvent.started()),
          ),

          BlocProvider(
            create: (context) => OverlayWindowBloc(
              toMainMsgService: context.read<ToMainMsgService>(),
              layoutChannelService: context.read<LayoutChannelService>(),
            ),
          ),
          BlocProvider(
            create: (context) => MsgToMainBloc(
              toMainMsgService: context.read<ToMainMsgService>(),
            ),
          ),
        ],
        child: Builder(
          builder: (context) => widget.builder(context, _appRouter),
        ),
      ),
    );
  }
}

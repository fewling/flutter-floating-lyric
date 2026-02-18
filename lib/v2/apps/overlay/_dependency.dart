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

    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => ToMainMessageService()),
        RepositoryProvider(create: (context) => LayoutChannelService()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                OverlayAppBloc()..add(const OverlayAppEvent.started()),
          ),

          BlocProvider(
            create: (context) => OverlayWindowBloc(
              toMainMessageService: context.read<ToMainMessageService>(),
              layoutChannelService: context.read<LayoutChannelService>(),
            ),
          ),

          BlocProvider(
            lazy: false,
            create: (context) =>
                MsgFromMainBloc()..add(const MsgFromMainEvent.started()),
          ),
        ],
        child: Builder(
          builder: (context) => widget.builder(context, _appRouter),
        ),
      ),
    );
  }
}

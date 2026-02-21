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

  late final ToMainMsgService _toMainMsgService;
  late final LayoutChannelService _layoutChannelService;

  late final OverlayAppBloc _overlayAppBloc;
  late final MsgFromMainBloc _msgFromMainBloc;
  late final OverlayWindowBloc _overlayWindowBloc;
  late final MsgToMainBloc _msgToMainBloc;

  @override
  void initState() {
    super.initState();

    _toMainMsgService = ToMainMsgService();
    _layoutChannelService = LayoutChannelService();

    _overlayAppBloc = OverlayAppBloc();
    _msgFromMainBloc = MsgFromMainBloc();
    _overlayWindowBloc = OverlayWindowBloc(
      toMainMsgService: _toMainMsgService,
      layoutChannelService: _layoutChannelService,
    );
    _msgToMainBloc = MsgToMainBloc(toMainMsgService: _toMainMsgService);

    _appRouter = AppRouter.overlay();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _overlayAppBloc.add(const OverlayAppEvent.started());
      _msgFromMainBloc.add(const MsgFromMainEvent.started());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _toMainMsgService),
        RepositoryProvider.value(value: _layoutChannelService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _overlayAppBloc),
          BlocProvider.value(value: _msgFromMainBloc),
          BlocProvider.value(value: _overlayWindowBloc),
          BlocProvider.value(value: _msgToMainBloc),
        ],
        child: Builder(
          builder: (context) => widget.builder(context, _appRouter),
        ),
      ),
    );
  }
}

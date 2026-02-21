part of 'overlay_app.dart';

class OverlayAppDependency extends StatefulWidget {
  const OverlayAppDependency({
    required this.lrcBox,
    required this.builder,
    super.key,
  });

  final Widget Function(BuildContext context, AppRouter appRouter) builder;
  final IsolatedBox<LrcModel> lrcBox;

  static BuildContext of(BuildContext context) => context;

  @override
  State<OverlayAppDependency> createState() => _OverlayAppDependencyState();
}

class _OverlayAppDependencyState extends State<OverlayAppDependency> {
  late final AppRouter _appRouter;

  late final LocalDbRepo _localDbRepo;

  late final ToMainMsgService _toMainMsgService;
  late final LayoutChannelService _layoutChannelService;
  late final LocalDbService _localDbService;
  late final LrcProcessorService _lrcProcessorService;

  late final OverlayAppBloc _overlayAppBloc;
  late final MsgFromMainBloc _msgFromMainBloc;
  late final OverlayWindowBloc _overlayWindowBloc;
  late final MsgToMainBloc _msgToMainBloc;
  late final LyricListBloc _lyricListBloc;

  @override
  void initState() {
    super.initState();

    _localDbRepo = LocalDbRepo(lrcBox: widget.lrcBox);

    _toMainMsgService = ToMainMsgService();
    _layoutChannelService = LayoutChannelService();
    _localDbService = LocalDbService(localDBRepo: _localDbRepo);
    _lrcProcessorService = LrcProcessorService();

    _overlayAppBloc = OverlayAppBloc();
    _msgFromMainBloc = MsgFromMainBloc();
    _overlayWindowBloc = OverlayWindowBloc(
      toMainMsgService: _toMainMsgService,
      layoutChannelService: _layoutChannelService,
    );
    _msgToMainBloc = MsgToMainBloc(toMainMsgService: _toMainMsgService);
    _lyricListBloc = LyricListBloc(
      localDbService: _localDbService,
      lrcProcessorService: _lrcProcessorService,
    );

    _appRouter = AppRouter.overlay();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _overlayAppBloc.add(const OverlayAppEvent.started());
      _msgFromMainBloc.add(const MsgFromMainEvent.started());
      _lyricListBloc.add(const LyricListEvent.started());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _toMainMsgService),
        RepositoryProvider.value(value: _layoutChannelService),
        RepositoryProvider.value(value: _localDbService),
        RepositoryProvider.value(value: _lrcProcessorService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _overlayAppBloc),
          BlocProvider.value(value: _msgFromMainBloc),
          BlocProvider.value(value: _overlayWindowBloc),
          BlocProvider.value(value: _msgToMainBloc),
          BlocProvider.value(value: _lyricListBloc),
        ],
        child: Builder(
          builder: (context) => widget.builder(context, _appRouter),
        ),
      ),
    );
  }
}

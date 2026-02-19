part of 'main_app.dart';

class MainAppDependency extends StatefulWidget {
  const MainAppDependency({
    required this.lrcBox,
    required this.pref,
    required this.builder,
    super.key,
  });

  final Widget Function(BuildContext context, AppRouter appRouter) builder;
  final Box<LrcModel> lrcBox;
  final SharedPreferences pref;

  static BuildContext of(BuildContext context) => context;

  @override
  State<MainAppDependency> createState() => _MainAppDependencyState();
}

class _MainAppDependencyState extends State<MainAppDependency> {
  late final AppRouter appRouter;

  late final PreferenceRepo _preferenceRepo;
  late final LocalDbRepo _localDbRepo;

  late final PermissionChannelService _permissionChannelService;
  late final MethodChannelService _methodChannelService;
  late final ToOverlayMsgService _toOverlayMsgService;
  late final LrcProcessorService _lrcProcessorService;

  late final PermissionBloc _permissionBloc;
  late final PreferenceBloc _preferenceBloc;
  late final MediaListenerBloc _mediaListenerBloc;
  late final OverlayWindowSettingsBloc _overlayWindowSettingsBloc;
  late final MsgToOverlayBloc _msgToOverlayBloc;

  @override
  void initState() {
    super.initState();

    // repos:
    _preferenceRepo = PreferenceRepo(sharedPreferences: widget.pref);
    _localDbRepo = LocalDbRepo(lrcBox: widget.lrcBox);

    // services:
    _permissionChannelService = PermissionChannelService();
    _methodChannelService = MethodChannelService();
    _toOverlayMsgService = ToOverlayMsgService();
    _lrcProcessorService = LrcProcessorService(localDB: _localDbRepo);

    // blocs:
    _permissionBloc = PermissionBloc(
      permissionChannelService: _permissionChannelService,
    );
    _preferenceBloc = PreferenceBloc(preferenceRepo: _preferenceRepo);
    _mediaListenerBloc = MediaListenerBloc();
    _overlayWindowSettingsBloc = OverlayWindowSettingsBloc(
      methodChannelService: _methodChannelService,
    );
    _msgToOverlayBloc = MsgToOverlayBloc(
      toOverlayMsgService: _toOverlayMsgService,
    );

    appRouter = AppRouter.standard(permissionBloc: _permissionBloc);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _permissionBloc.add(const PermissionEvent.init());
      _mediaListenerBloc.add(const MediaListenerEvent.started());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _preferenceRepo),
        RepositoryProvider.value(value: _localDbRepo),

        RepositoryProvider.value(value: _permissionChannelService),
        RepositoryProvider.value(value: _methodChannelService),
        RepositoryProvider.value(value: _toOverlayMsgService),
        RepositoryProvider.value(value: _lrcProcessorService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _preferenceBloc),
          BlocProvider.value(value: _permissionBloc),
          BlocProvider.value(value: _mediaListenerBloc),
          BlocProvider.value(value: _overlayWindowSettingsBloc),
          BlocProvider.value(value: _msgToOverlayBloc),
          BlocProvider(
            lazy: false,
            create: (context) =>
                MsgFromOverlayBloc()..add(const MsgFromOverlayEvent.started()),
          ),
        ],
        child: Builder(
          builder: (context) => widget.builder(context, appRouter),
        ),
      ),
    );
  }
}

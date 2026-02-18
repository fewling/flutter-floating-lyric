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

  @override
  State<MainAppDependency> createState() => _MainAppDependencyState();
}

class _MainAppDependencyState extends State<MainAppDependency> {
  late final AppRouter appRouter;

  late final PreferenceRepo _preferenceRepo;

  late final PermissionChannelService _permissionChannelService;

  late final PermissionBloc _permissionBloc;
  late final PreferenceBloc _preferenceBloc;

  @override
  void initState() {
    super.initState();

    // repos:
    _preferenceRepo = PreferenceRepo(sharedPreferences: widget.pref);

    // services:
    _permissionChannelService = PermissionChannelService();

    // blocs:
    _permissionBloc = PermissionBloc(
      permissionChannelService: _permissionChannelService,
    );
    _preferenceBloc = PreferenceBloc(preferenceRepo: _preferenceRepo);

    appRouter = AppRouter.standard(permissionBloc: _permissionBloc);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _permissionBloc.add(const PermissionEvent.init());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _preferenceRepo),
        RepositoryProvider.value(value: _permissionChannelService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _preferenceBloc),
          BlocProvider.value(value: _permissionBloc),
        ],
        child: Builder(
          builder: (context) => widget.builder(context, appRouter),
        ),
      ),
    );
  }
}

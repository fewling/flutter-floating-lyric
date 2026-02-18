part of 'page.dart';

class _View extends StatefulWidget {
  const _View();

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  /// This is to handle the case when user grant SystemAlertWindow permission
  /// but the result is not returned from native Android code.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        context.read<PermissionBloc>().add(const PermissionEvent.init());

      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    const pageDecoration = PageDecoration(
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: EdgeInsets.zero,
    );

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(Icons.language, semanticLabel: l10n.language),
                const SizedBox(width: 8),
                LanguageSelector(
                  value: context.select(
                    (PreferenceBloc bloc) => bloc.state.locale,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: DefaultTextStyle(
        style: GoogleFonts.getFont(
          context.select((PreferenceBloc bloc) => bloc.state.fontFamily),
        ),
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: l10n.permission_screen_notif_listener_permission_title,
              bodyWidget: const _NotificationListenerPermissionPageBody(),
              image: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Lottie.asset('assets/images/music-player-pop-up.json'),
              ),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: l10n.permission_screen_overlay_window_permission_title,
              bodyWidget: const _SystemAlertWindowPermissionPageBody(),
              image: Lottie.asset('assets/images/stack.json'),
              decoration: pageDecoration,
            ),
          ],
          onDone: () => _onIntroEnd(context),
          skipOrBackFlex: 0,
          nextFlex: 0,
          showBackButton: true,
          back: const Icon(Icons.arrow_back),
          next: const Icon(Icons.arrow_forward),
          done: Text(
            l10n.permission_screen_done,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          curve: Curves.fastLinearToSlowEaseIn,
          controlsPadding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 4.0,
          ),
          dotsDecorator: DotsDecorator(
            size: const Size(10.0, 10.0),
            color: const Color(0xFFBDBDBD),
            activeSize: const Size(22.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          dotsContainerDecorator: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }

  void _onIntroEnd(BuildContext context) {
    final permissionBloc = context.read<PermissionBloc>();
    final l10n = context.l10n;

    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: permissionBloc,
        child: AlertDialog(
          title: Text(l10n.permission_screen_missing_permission),
          content: Text(l10n.permission_screen_enable_permissions),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Builder(
                  builder: (context) {
                    final isNotificationListenerGranted = context
                        .select<PermissionBloc, bool>(
                          (bloc) => bloc.state.isNotificationListenerGranted,
                        );
                    return ElevatedButton(
                      onPressed: isNotificationListenerGranted
                          ? null
                          : () => permissionBloc.add(
                              const PermissionEvent.requestNotificationListenerPermission(),
                            ),
                      child: Text(l10n.permission_screen_notification_access),
                    );
                  },
                ),
                Builder(
                  builder: (context) {
                    final isSystemAlertWindowGranted = context
                        .select<PermissionBloc, bool>(
                          (bloc) => bloc.state.isSystemAlertWindowGranted,
                        );

                    return ElevatedButton(
                      onPressed: isSystemAlertWindowGranted
                          ? null
                          : () => permissionBloc.add(
                              const PermissionEvent.requestSystemAlertWindowPermission(),
                            ),
                      child: Text(
                        l10n.permission_screen_display_window_over_apps,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

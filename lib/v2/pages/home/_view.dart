part of 'page.dart';

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final mediaStates = context.watch<MediaListenerBloc>().state.mediaStates;

    return DefaultTabController(
      length: 3,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: switch (mediaStates.isEmpty) {
              true => _NoMediaTile(
                onStartMusicApp: () => _startMusicApp(context),
                onLearnMore: () => _onLearnMore(context),
                onReEnableListener: () {
                  // context.read<OverlayWindowSettingsBloc>().add(
                  //   const ToggleNotiListenerSettings(),
                  // );
                },
              ),
              false => _MediaStateCarousel(mediaStates: mediaStates),
            },
          ),
          SliverToBoxAdapter(
            child: TabBar(
              tabs: [
                Tab(
                  text: l10n.home_screen_window_configs,
                  icon: const Icon(Icons.window_outlined),
                ),
                Tab(
                  text: l10n.home_screen_import_lyrics,
                  icon: const Icon(Icons.folder_copy_outlined),
                ),
                Tab(
                  text: l10n.home_screen_online_lyrics,
                  icon: const Icon(Icons.cloud_outlined),
                ),
              ],
            ),
          ),
          const SliverFillRemaining(
            child: TabBarView(
              children: [
                _WindowConfigTab(),
                Placeholder(),
                Placeholder(),
                // OverlayWindowSetting(),
                // ImportLocalLrc(),
                // FetchOnlineLrcForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startMusicApp(BuildContext context) => context
      .read<StartMusicAppBloc>()
      .add(const StartMusicAppEvent.startMusicApp());

  void _onLearnMore(BuildContext context) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.info_outline),
      title: Text(context.l10n.media_state_notification_listener_title),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Text(context.l10n.media_state_notification_listener_info1),
          Text(context.l10n.media_state_notification_listener_info2),
          Text(context.l10n.media_state_notification_listener_info3),
          Text(context.l10n.media_state_notification_listener_info4),
        ],
      ),
    ),
  );
}

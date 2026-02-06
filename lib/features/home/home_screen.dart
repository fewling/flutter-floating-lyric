import 'package:flutter/material.dart';

import '../../utils/extensions/custom_extensions.dart';
import '../fetch_online_lrc/fetch_online_lrc_form.dart';
import '../import_local_lrc/import_local_lrc.dart';
import '../lyric_state_listener/media_state_info.dart';
import '../overlay_window_settings/overlay_window_settings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DefaultTabController(
      length: 3,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: MediaStateInfo()),
          SliverToBoxAdapter(
            child: TabBar(
              tabs: [
                Tab(text: l10n.home_screen_window_configs, icon: Icon(Icons.window_outlined)),
                Tab(
                  text: l10n.home_screen_import_lyrics,
                  icon: Icon(Icons.folder_copy_outlined),
                ),
                Tab(text: l10n.home_screen_online_lyrics, icon: Icon(Icons.cloud_outlined)),
              ],
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              children: [
                OverlayWindowSetting(),
                ImportLocalLrc(),
                FetchOnlineLrcForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

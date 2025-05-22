import 'package:flutter/material.dart';

import '../fetch_online_lrc/fetch_online_lrc_form.dart';
import '../import_local_lrc/import_local_lrc.dart';
import '../lyric_state_listener/media_state_info.dart';
import '../overlay_window_settings/overlay_window_settings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 3,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: MediaStateInfo()),
          SliverToBoxAdapter(
            child: TabBar(
              tabs: [
                Tab(text: 'Window Configs', icon: Icon(Icons.window_outlined)),
                Tab(
                  text: 'Import Lyrics',
                  icon: Icon(Icons.folder_copy_outlined),
                ),
                Tab(text: 'Online Lyrics', icon: Icon(Icons.cloud_outlined)),
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

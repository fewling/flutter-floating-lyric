import 'package:flutter/material.dart';

import '../../utils/extensions/custom_extensions.dart';
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
          const SliverToBoxAdapter(child: MediaStateInfo()),
          SliverToBoxAdapter(
            child: TabBar(
              tabs: [
                Tab(
                  text: l10n.home_screen_window_configs,
                  icon: const Icon(Icons.window_outlined),
                ),
              ],
            ),
          ),
          const SliverFillRemaining(
            child: TabBarView(children: [OverlayWindowSetting()]),
          ),
        ],
      ),
    );
  }
}

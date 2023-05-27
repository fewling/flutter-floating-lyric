import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../services/app_preference.dart';
import 'main_state_provider.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainStateProvider);
    final brightness = Theme.of(context).brightness;

    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: NavigationRail(
              extended: true,
              selectedIndex: state.screenIndex,
              onDestinationSelected: (index) {
                ref.read(mainStateProvider.notifier).updateScreenIndex(index);
                Navigator.pop(context);
              },
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.window_outlined),
                  label: Text('Floating Window'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.audio_file_outlined),
                  label: Text('Stored Lyric'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    final inAppReview = InAppReview.instance;
                    inAppReview.openStoreListing();
                  },
                  icon: const Icon(Icons.rate_review_outlined),
                ),
                IconButton.filledTonal(
                  onPressed: () =>
                      ref.read(preferenceProvider.notifier).toggleBrightness(),
                  icon: Icon(brightness == Brightness.light
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

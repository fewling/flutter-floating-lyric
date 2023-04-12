import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main_state_provider.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainStateProvider);
    return Drawer(
      child: ListView.builder(
        itemCount: state.screens.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(state.screens[index].title),
          selected: state.screenIndex == index,
          onTap: () {
            ref.read(mainStateProvider.notifier).updateScreenIndex(index);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

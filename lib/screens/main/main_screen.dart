import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../lyric_screen/lyric_screen_state_provider.dart';
import 'main_drawer.dart';
import 'main_state_provider.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  static const eventChannel = EventChannel('Floating Lyric Channel');
  late final StreamSubscription<dynamic> subscription;

  @override
  void initState() {
    super.initState();
    subscription = eventChannel.receiveBroadcastStream().listen((event) =>
        ref.read(lyricStateProvider.notifier).updateFromEventChannel(event));
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mainStateProvider);
    final notifier = ref.watch(mainStateProvider.notifier);

    final metaData = state.screens[state.screenIndex];

    final currentChild = metaData.child;
    final title = metaData.title;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: const MainDrawer(),
      body: currentChild,
    );
  }
}

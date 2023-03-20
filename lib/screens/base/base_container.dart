import 'dart:async';
import 'dart:developer';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:system_alert_window/system_alert_window.dart';

import '../../models/song.dart';
import '../../service/floating_window_state.dart';
import '../../ui/lyric_list.dart';
import '../instruction/instruction.dart';
import '../window_settings/window_settings_page.dart';

class BaseContainer extends ConsumerStatefulWidget {
  const BaseContainer({super.key});

  @override
  ConsumerState<BaseContainer> createState() => _BaseContainerState();
}

class _BaseContainerState extends ConsumerState<BaseContainer> {
  final String _featureId = 'id_how_to_use';

  int _index = 0;
  final _pages = const [
    HomePage(),
    LyricList(),
    InstructionPage(),
  ];

  static const _eventChannel = EventChannel('Floating Lyric Channel');
  late StreamSubscription _streamSubscription;
  final StreamController<Song> _songStreamController = StreamController();

  @override
  void initState() {
    _streamSubscription = _eventChannel.receiveBroadcastStream().listen(
        (data) => _songStreamController.add(Song.fromJson(data as Map<String, dynamic>)),
        onError: (error) => log('Received error: ${error.message}'),
        cancelOnError: true);

    _songStreamController.stream.listen((song) {
      final floatingNotifer = ref.read(floatingStateProvider.notifier);
      floatingNotifer.updateSong(song);
    });

    SystemAlertWindow.requestPermissions(prefMode: SystemWindowPrefMode.OVERLAY);

    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      FeatureDiscovery.discoverFeatures(
        context,
        [_featureId],
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    _songStreamController.close();
    // LyricWindow().close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _pages[_index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: (index) => setState(() => _index = index),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.window_outlined), label: 'Window'),
          const BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Lyrics'),
          BottomNavigationBarItem(
            icon: DescribedFeatureOverlay(
              featureId: _featureId,
              tapTarget: const Icon(Icons.question_mark_outlined),
              description: Text(
                'First-time user may take a look here to learn how to use this app',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: Colors.white),
              ),
              child: const Icon(Icons.question_mark_outlined),
            ),
            label: 'How to Use',
          ),
        ],
      ),
    );
  }
}

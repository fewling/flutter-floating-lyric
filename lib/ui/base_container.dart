import 'dart:async';
import 'dart:developer';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:floating_lyric/ui/homepage.dart';
import 'package:floating_lyric/ui/instruction.dart';
import 'package:floating_lyric/ui/lyric_list.dart';
import 'package:floating_lyric/ui/lyric_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:system_alert_window/system_alert_window.dart';

import '../models/song.dart';
import '../singletons/window_controller.dart';

class BaseContainer extends StatefulWidget {
  const BaseContainer({Key? key}) : super(key: key);

  @override
  State<BaseContainer> createState() => _BaseContainerState();
}

class _BaseContainerState extends State<BaseContainer> {
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

  late WindowController _windowController;

  @override
  void initState() {
    _windowController = Get.find<WindowController>();

    _streamSubscription = _eventChannel.receiveBroadcastStream().listen(
        (data) => _songStreamController.add(Song.fromMap(data as Map)),
        onError: (error) => log('Received error: ${error.message}'),
        cancelOnError: true);

    _songStreamController.stream
        .listen((song) => _windowController.song = song);

    SystemAlertWindow.requestPermissions(
        prefMode: SystemWindowPrefMode.OVERLAY);

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
    log('dispose');

    _streamSubscription.cancel();
    _songStreamController.close();
    LyricWindow().close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _windowController.maxWidth = MediaQuery.of(context).size.width;

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
          const BottomNavigationBarItem(
              icon: Icon(Icons.window_outlined), label: 'Window'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.list), label: 'Lyrics'),
          BottomNavigationBarItem(
            icon: DescribedFeatureOverlay(
              featureId: _featureId,
              tapTarget: const Icon(Icons.question_mark_outlined),
              description: Text(
                'First-time user may take a look here to learn how to use this app',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(color: Colors.white),
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

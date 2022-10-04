import 'dart:async';
import 'dart:developer';
import 'package:floating_lyric/ui/homepage.dart';
import 'package:floating_lyric/ui/lyric_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  int _index = 0;
  final _pages = [const HomePage(), const LyricList()];

  static const _eventChannel = EventChannel('event_channel');
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

    super.initState();
  }

  @override
  void dispose() {
    log('dispose');

    _streamSubscription.cancel();
    _songStreamController.close();
    FlutterLocalNotificationsPlugin().cancelAll();

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
        currentIndex: _index,
        onTap: (index) => setState(() => _index = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Lyrics'),
        ],
      ),
    );
  }
}

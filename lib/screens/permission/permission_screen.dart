import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../../services/permission_provider.dart';

class PermissionScreen extends ConsumerStatefulWidget {
  const PermissionScreen({super.key});

  @override
  ConsumerState<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends ConsumerState<PermissionScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  /// This is to handle the case when user grant SystemAlertWindow permission
  /// but the result is not returned from native Android code.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    Logger.d('didChangeAppLifecycleState: $state');

    if (state == AppLifecycleState.resumed) {
      ref.read(permissionStateProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final permissionState = ref.watch(permissionStateProvider);
    final permissionNotifier = ref.watch(permissionStateProvider.notifier);

    Logger.d('''
    permissionState.isSystemAlertWindowGranted: ${permissionState.isSystemAlertWindowGranted}
    permissionState.isNotificationListenerGranted: ${permissionState.isNotificationListenerGranted}
    ''');
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: 'Notification Listener Permission',
          bodyWidget: Column(
            children: [
              const Text(
                '''
This app needs to access the music player in the notification bar to work.

Grant Access button -> this app -> Turn on Allow notification access
''',
                style: bodyStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: permissionState.isNotificationListenerGranted
                      ? null
                      : permissionNotifier.requestNotificationListener,
                  child: const Text('Grant Access'),
                ),
              ),
            ],
          ),
          image: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Lottie.asset('assets/images/music-player-pop-up.json'),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: 'Overlay Window Permission',
          bodyWidget: Column(
            children: [
              const Text(
                '''
This permission is required to display floating window on top of other apps.

Grant Access button -> this app >> Turn on `Allow display over other apps`
''',
                style: bodyStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: permissionState.isSystemAlertWindowGranted
                      ? null
                      : permissionNotifier.requestSystemAlertWindow,
                  child: const Text('Grant Access'),
                ),
              ),
            ],
          ),
          image: Lottie.asset('assets/images/stack.json'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context, ref),
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      back: const Icon(Icons.arrow_back),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsPadding:
          const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: const Color(0xFFBDBDBD),
        activeSize: const Size(22.0, 10.0),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
      dotsContainerDecorator: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }

  void _onIntroEnd(BuildContext context, WidgetRef ref) {
    final permissionState = ref.watch(permissionStateProvider);
    final permissionNotifier = ref.watch(permissionStateProvider.notifier);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Missing Permission'),
        content: const Text('Please enable the permissions to proceed.'),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: permissionState.isNotificationListenerGranted
                    ? null
                    : permissionNotifier.requestNotificationListener,
                child: const Text('Notification Access'),
              ),
              ElevatedButton(
                onPressed: permissionState.isSystemAlertWindowGranted
                    ? null
                    : permissionNotifier.requestSystemAlertWindow,
                child: const Text('Display Window Over Apps'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

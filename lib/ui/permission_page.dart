import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import '../singletons/permission_manager.dart';

class PermissionPage extends StatelessWidget {
  const PermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    final manager = Get.find<PermissionManager>();

    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Notification Listener Permission",
          bodyWidget: Column(
            children: [
              const Text(
                '''
This app needs to access the music player in the nofication bar to work.

Grant Access button -> this app -> Turn on Allow notification access
''',
                style: bodyStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 150,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: manager.isNotificationListenerGranted
                        ? null
                        : () => manager.requestNotificationListener(),
                    child: const Text('Grant Access'),
                  ),
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
          title: "Overlay Window Permission",
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
                child: Obx(
                  () => ElevatedButton(
                      onPressed: manager.isSystemAlertWindowGranted
                          ? null
                          : () => manager.requestSystemAlertWindowPermission(),
                      child: const Text('Grant Access')),
                ),
              ),
            ],
          ),
          image: Lottie.asset('assets/images/stack.json'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      back: const Icon(Icons.arrow_back),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }

  void _onIntroEnd(context) {
    final manager = Get.find<PermissionManager>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Missing Permission'),
        content: const Text('Please enable the permissions to proceed.'),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Obx(
                () => ElevatedButton(
                  onPressed: manager.isNotificationListenerGranted
                      ? null
                      : () => manager.requestNotificationListener(),
                  child: const Text('Notification Access'),
                ),
              ),
              Obx(
                () => ElevatedButton(
                    onPressed: manager.isSystemAlertWindowGranted
                        ? null
                        : () => manager.requestSystemAlertWindowPermission(),
                    child: const Text('Display Window Over Apps')),
              ),
            ],
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../../utils/logger.dart';
import '../preference/bloc/preference_bloc.dart';
import 'bloc/permission_bloc.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> with WidgetsBindingObserver {
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
    logger.t('didChangeAppLifecycleState: $state');

    if (state == AppLifecycleState.resumed) {
      context.read<PermissionBloc>().add(const PermissionEventInitial());
    }
  }

  @override
  Widget build(BuildContext context) {
    const pageDecoration = PageDecoration(
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: EdgeInsets.zero,
    );

    final fontFamily = context.select((PreferenceBloc bloc) => bloc.state.fontFamily);
    return DefaultTextStyle(
      style: GoogleFonts.getFont(fontFamily),
      child: IntroductionScreen(
        pages: [
          PageViewModel(
            title: 'Notification Listener Permission',
            bodyWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('This app needs to access the music player in the notification bar to work.\n'),
                const Text('1. Grant Access button'),
                const Text('2. This app'),
                const Text('3. Turn on "Allow notification access"'),
                const SizedBox(height: 8),
                Center(
                  child: SizedBox(
                    width: 150,
                    child: Builder(builder: (context) {
                      final isNotificationListenerGranted = context.select<PermissionBloc, bool>(
                        (bloc) => bloc.state.isNotificationListenerGranted,
                      );

                      return ElevatedButton(
                        onPressed: isNotificationListenerGranted
                            ? null
                            : () => context.read<PermissionBloc>().add(const NotificationListenerRequested()),
                        child: const Text('Grant Access'),
                      );
                    }),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('This permission is required to display floating window on top of other apps.\n'),
                const Text('1. Grant Access button'),
                const Text('2. This app'),
                const Text('3. Turn on "Allow display over other apps"'),
                const SizedBox(height: 8),
                Center(
                  child: SizedBox(
                    width: 150,
                    child: Builder(builder: (context) {
                      final isSystemAlertWindowGranted = context.select<PermissionBloc, bool>(
                        (bloc) => bloc.state.isSystemAlertWindowGranted,
                      );

                      return ElevatedButton(
                        onPressed: isSystemAlertWindowGranted
                            ? null
                            : () => context.read<PermissionBloc>().add(const SystemAlertWindowRequested()),
                        child: const Text('Grant Access'),
                      );
                    }),
                  ),
                ),
              ],
            ),
            image: Lottie.asset('assets/images/stack.json'),
            decoration: pageDecoration,
          ),
        ],
        onDone: () => _onIntroEnd(context),
        skipOrBackFlex: 0,
        nextFlex: 0,
        showBackButton: true,
        back: const Icon(Icons.arrow_back),
        next: const Icon(Icons.arrow_forward),
        done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
        curve: Curves.fastLinearToSlowEaseIn,
        controlsPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        dotsDecorator: DotsDecorator(
          size: const Size(10.0, 10.0),
          color: const Color(0xFFBDBDBD),
          activeSize: const Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
        dotsContainerDecorator: ShapeDecoration(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    );
  }

  void _onIntroEnd(BuildContext context) {
    final permissionBloc = context.read<PermissionBloc>();

    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: permissionBloc,
        child: AlertDialog(
          title: const Text('Missing Permission'),
          content: const Text('Please enable the permissions to proceed.'),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Builder(builder: (context) {
                  final isNotificationListenerGranted = context.select<PermissionBloc, bool>(
                    (bloc) => bloc.state.isNotificationListenerGranted,
                  );
                  return ElevatedButton(
                    onPressed: isNotificationListenerGranted
                        ? null
                        : () => permissionBloc.add(const NotificationListenerRequested()),
                    child: const Text('Notification Access'),
                  );
                }),
                Builder(builder: (context) {
                  final isSystemAlertWindowGranted = context.select<PermissionBloc, bool>(
                    (bloc) => bloc.state.isSystemAlertWindowGranted,
                  );

                  return ElevatedButton(
                    onPressed: isSystemAlertWindowGranted
                        ? null
                        : () => permissionBloc.add(const SystemAlertWindowRequested()),
                    child: const Text('Display Window Over Apps'),
                  );
                }),
              ],
            )
          ],
        ),
      ),
    );
  }
}

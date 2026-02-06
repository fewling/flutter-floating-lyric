import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../../utils/extensions/custom_extensions.dart';
import '../../utils/logger.dart';
import '../../widgets/language_selector.dart';
import '../preference/bloc/preference_bloc.dart';
import 'bloc/permission_bloc.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen>
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
    logger.t('didChangeAppLifecycleState: $state');

    if (state == AppLifecycleState.resumed) {
      context.read<PermissionBloc>().add(const PermissionEventInitial());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    const pageDecoration = PageDecoration(
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: EdgeInsets.zero,
    );

    final fontFamily = context.select(
      (PreferenceBloc bloc) => bloc.state.fontFamily,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.language),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: LanguageSelector(),
          ),
        ],
      ),
      body: DefaultTextStyle(
        style: GoogleFonts.getFont(fontFamily),
        child: IntroductionScreen(
          pages: [
          PageViewModel(
            title: l10n.permission_screen_notif_listener_permission_title,
            bodyWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.permission_screen_notif_listener_permission_instruction,
                ),
                const SizedBox(height: 8),
                Text(l10n.permission_screen_notif_listener_permission_step1),
                Text(l10n.permission_screen_notif_listener_permission_step2),
                Text(l10n.permission_screen_notif_listener_permission_step3),
                const SizedBox(height: 8),
                Center(
                  child: SizedBox(
                    width: 150,
                    child: Builder(
                      builder: (context) {
                        final isNotificationListenerGranted = context
                            .select<PermissionBloc, bool>(
                              (bloc) =>
                                  bloc.state.isNotificationListenerGranted,
                            );

                        return ElevatedButton(
                          onPressed: isNotificationListenerGranted
                              ? null
                              : () => context.read<PermissionBloc>().add(
                                  const NotificationListenerRequested(),
                                ),
                          child: Text(l10n.permission_screen_grant_access),
                        );
                      },
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
            title: l10n.permission_screen_overlay_window_permission_title,
            bodyWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.permission_screen_overlay_window_permission_instruction,
                ),
                const SizedBox(height: 8),
                Text(l10n.permission_screen_overlay_window_permission_step1),
                Text(l10n.permission_screen_overlay_window_permission_step2),
                Text(l10n.permission_screen_overlay_window_permission_step3),
                const SizedBox(height: 8),
                Center(
                  child: SizedBox(
                    width: 150,
                    child: Builder(
                      builder: (context) {
                        final isSystemAlertWindowGranted = context
                            .select<PermissionBloc, bool>(
                              (bloc) => bloc.state.isSystemAlertWindowGranted,
                            );

                        return ElevatedButton(
                          onPressed: isSystemAlertWindowGranted
                              ? null
                              : () => context.read<PermissionBloc>().add(
                                  const SystemAlertWindowRequested(),
                                ),
                          child: Text(l10n.permission_screen_grant_access),
                        );
                      },
                    ),
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
        done: Text(
          l10n.permission_screen_done,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        curve: Curves.fastLinearToSlowEaseIn,
        controlsPadding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 4.0,
        ),
        dotsDecorator: DotsDecorator(
          size: const Size(10.0, 10.0),
          color: const Color(0xFFBDBDBD),
          activeSize: const Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        dotsContainerDecorator: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    ));
  }

  void _onIntroEnd(BuildContext context) {
    final permissionBloc = context.read<PermissionBloc>();
    final l10n = context.l10n;

    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: permissionBloc,
        child: AlertDialog(
          title: Text(l10n.permission_screen_missing_permission),
          content: Text(l10n.permission_screen_enable_permissions),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Builder(
                  builder: (context) {
                    final isNotificationListenerGranted = context
                        .select<PermissionBloc, bool>(
                          (bloc) => bloc.state.isNotificationListenerGranted,
                        );
                    return ElevatedButton(
                      onPressed: isNotificationListenerGranted
                          ? null
                          : () => permissionBloc.add(
                              const NotificationListenerRequested(),
                            ),
                      child: Text(l10n.permission_screen_notification_access),
                    );
                  },
                ),
                Builder(
                  builder: (context) {
                    final isSystemAlertWindowGranted = context
                        .select<PermissionBloc, bool>(
                          (bloc) => bloc.state.isSystemAlertWindowGranted,
                        );

                    return ElevatedButton(
                      onPressed: isSystemAlertWindowGranted
                          ? null
                          : () => permissionBloc.add(
                              const SystemAlertWindowRequested(),
                            ),
                      child: Text(
                        l10n.permission_screen_display_window_over_apps,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

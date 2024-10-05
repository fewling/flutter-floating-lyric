import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/from_overlay_msg_model.dart';
import '../../repos/local/local_db_repo.dart';
import '../../repos/local/preference_repo.dart';
import '../../service/db/local/local_db_service.dart';
import '../../service/message_channels/to_overlay_message_service.dart';
import '../../service/platform_methods/window_channel_service.dart';
import '../../service/preference/preference_service.dart';
import '../../services/lrclib/repo/lrclib_repository.dart';
import '../../utils/logger.dart';
import '../app_info/bloc/app_info_bloc.dart';
import '../lyric_state_listener/bloc/lyric_state_listener_bloc.dart';
import '../message_channels/message_from_overlay_receiver/bloc/message_from_overlay_receiver_bloc.dart';
import '../overlay_window_settings/bloc/overlay_window_settings_bloc.dart';
import '../permissions/bloc/permission_bloc.dart';
import '../preference/bloc/preference_bloc.dart';

class GlobalDependencyInjector extends StatelessWidget {
  const GlobalDependencyInjector({
    super.key,
    required this.child,
    required this.isar,
    required this.pref,
    required this.permissionBloc,
  });

  final Widget child;
  final Isar isar;
  final SharedPreferences pref;
  final PermissionBloc permissionBloc;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => LocalDbRepo(isar),
        ),
        RepositoryProvider(
          create: (context) => LrcLibRepository(),
        ),
        RepositoryProvider(
          create: (context) => PreferenceRepo(sharedPreferences: pref),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: permissionBloc),
          BlocProvider(
            lazy: false,
            create: (context) => MessageFromOverlayReceiverBloc()..add(const MessageFromOverlayReceiverStarted()),
          ),
          BlocProvider(
            create: (context) => PreferenceBloc(
              spService: PreferenceService(spRepo: context.read<PreferenceRepo>()),
            )..add(const PreferenceEventLoad()),
          ),
          BlocProvider(
            create: (context) => AppInfoBloc()..add(const AppInfoLoaded()),
          ),
          BlocProvider(
            create: (context) => LyricStateListenerBloc(
              localDbService: LocalDbService(
                localDBRepo: context.read<LocalDbRepo>(),
              ),
              lyricRepository: context.read<LrcLibRepository>(),
            )..add(LyricStateListenerLoaded(
                isAutoFetch: context.read<PreferenceBloc>().state.autoFetchOnline,
                showLine2: context.read<PreferenceBloc>().state.showLine2,
              )),
          ),
          BlocProvider(
            create: (context) => OverlayWindowSettingsBloc(
              toOverlayMessageService: ToOverlayMessageService(),
              windowChannelService: WindowChannelService(),
            )..add(OverlayWindowSettingsLoaded(
                lyricStateListenerState: context.read<LyricStateListenerBloc>().state,
                preferenceState: context.read<PreferenceBloc>().state,
                screenWidth: screenWidth,
              )),
          ),
        ],
        child: PreferenceStateListener(
          child: LyricStateListener(
            child: MsgFromOverlayListener(
              child: OverlaySettingListener(
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PreferenceStateListener extends StatelessWidget {
  const PreferenceStateListener({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PreferenceBloc, PreferenceState>(
          listenWhen: (previous, current) => previous.autoFetchOnline != current.autoFetchOnline,
          listener: (context, state) => context.read<LyricStateListenerBloc>().add(
                AutoFetchUpdated(isAutoFetch: state.autoFetchOnline),
              ),
        ),
        BlocListener<PreferenceBloc, PreferenceState>(
          listenWhen: (previous, current) => previous.showLine2 != current.showLine2,
          listener: (context, state) => context.read<LyricStateListenerBloc>().add(
                ShowLine2Updated(showLine2: state.showLine2),
              ),
        ),
        BlocListener<PreferenceBloc, PreferenceState>(
          listener: (context, state) => context.read<OverlayWindowSettingsBloc>().add(
                PreferenceUpdated(preferenceState: state),
              ),
        ),
      ],
      child: child,
    );
  }
}

class LyricStateListener extends StatelessWidget {
  const LyricStateListener({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LyricStateListenerBloc, LyricStateListenerState>(
          listener: (context, state) =>
              context.read<OverlayWindowSettingsBloc>().add(LyricStateListenerUpdated(lyricStateListenerState: state)),
        ),
      ],
      child: child,
    );
  }
}

class MsgFromOverlayListener extends StatelessWidget {
  const MsgFromOverlayListener({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessageFromOverlayReceiverBloc, MessageFromOverlayReceiverState>(
      listener: (context, state) {
        logger.d('MessageFromOverlayReceiverBloc: $state');
        if (state.msg == null) return;

        if (state.msg?.action?.isClose ?? false) {
          context.read<OverlayWindowSettingsBloc>().add(const OverlayWindowVisibilityToggled(false));
        }

        context.read<MessageFromOverlayReceiverBloc>().add(const MsgOverlayHandled());
      },
      child: child,
    );
  }
}

class OverlaySettingListener extends StatelessWidget {
  const OverlaySettingListener({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<OverlayWindowSettingsBloc, OverlayWindowSettingsState>(
      listenWhen: (previous, current) => previous.isWindowVisible != current.isWindowVisible,
      listener: (context, state) {
        logger.w('isWindowVisible: ${state.isWindowVisible}');
      },
      child: child,
    );
  }
}

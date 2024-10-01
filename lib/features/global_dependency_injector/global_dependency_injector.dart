import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repos/local/local_db_repo.dart';
import '../../repos/local/preference_repo.dart';
import '../../service/db/local/local_db_service.dart';
import '../../service/overlay_window/overlay_window_service.dart';
import '../../service/preference/preference_service.dart';
import '../../services/lrclib/repo/lrclib_repository.dart';
import '../app_info/bloc/app_info_bloc.dart';
import '../lyric_state_listener/bloc/lyric_state_listener_bloc.dart';
import '../message_channels/message_from_overlay_receiver/bloc/message_from_overlay_receiver_bloc.dart';
import '../message_channels/message_from_overlay_receiver/message_from_overlay_receiver.dart';
import '../message_channels/message_to_overlay_sender/bloc/message_to_overlay_sender_bloc.dart';
import '../message_channels/message_to_overlay_sender/message_to_overlay_sender.dart';
import '../overlay_app/for_main_sides/overlay_window_listener.dart';
import '../overlay_window/bloc/overlay_window_bloc.dart';
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
            create: (context) => PreferenceBloc(
              spService: PreferenceService(spRepo: context.read<PreferenceRepo>()),
            )..add(const PreferenceEventLoad()),
          ),
          BlocProvider(
            create: (context) => AppInfoBloc()..add(const AppInfoLoaded()),
          ),
          BlocProvider(
            create: (context) => LyricStateListenerBloc(
              localDbService: LocalDbService(localDBRepo: context.read<LocalDbRepo>()),
              lyricRepository: context.read<LrcLibRepository>(),
            )..add(LyricStateListenerLoaded(
                isAutoFetch: context.read<PreferenceBloc>().state.autoFetchOnline,
                showLine2: context.read<PreferenceBloc>().state.showLine2,
              )),
          ),
        ],
        child: Builder(builder: (context) {
          final ratio = MediaQuery.of(context).devicePixelRatio;
          final pref = context.watch<PreferenceBloc>().state;

          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => OverlayWindowBloc(
                  overlayWindowService: OverlayWindowService(),
                  devicePixelRatio: ratio,
                )..add(OverlayWindowLoaded(
                    opacity: pref.opacity,
                    color: pref.color,
                    fontSize: pref.fontSize,
                    showProgressBar: pref.showProgressBar,
                    showMillis: pref.showMilliseconds,
                  )),
              ),
              BlocProvider(
                create: (context) => MessageFromOverlayReceiverBloc()..add(const MessageFromOverlayReceiverStarted()),
              ),
              BlocProvider(
                create: (context) => MessageToOverlaySenderBloc()..add(const MessageToOverlaySenderStarted()),
              ),
            ],
            child: MessageFromOverlayReceiver(
              child: MessageToOverlaySender(
                child: OverlayWindowListener(
                  child: child,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/db_helper.dart';
import '../../../services/lrclib/repo/lrclib_repository.dart';
import 'bloc/lyric_state_listener_bloc.dart';

class LyricStateListener extends ConsumerWidget {
  const LyricStateListener({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlocProvider(
      create: (context) => LyricStateListenerBloc(
        dbHelper: context.read<DBHelper>(),
        lyricRepository: context.read<LrcLibRepository>(),
      )..add(LyricStateListenerLoaded()),
      child: Builder(
        builder: (context) => MultiBlocListener(
          listeners: [
            BlocListener<LyricStateListenerBloc, LyricStateListenerState>(
              listenWhen: (previous, current) => previous != current,
              listener: (context, state) {},
            ),
          ],
          child: child,
        ),
      ),
    );
  }
}

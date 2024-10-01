import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../preference/bloc/preference_bloc.dart';
import 'bloc/lyric_state_listener_bloc.dart';

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
        BlocListener<PreferenceBloc, PreferenceState>(
          listenWhen: (previous, current) => previous.autoFetchOnline != current.autoFetchOnline,
          listener: (context, state) => context.read<LyricStateListenerBloc>().add(
                AutoFetchUpdated(
                  isAutoFetch: state.autoFetchOnline,
                ),
              ),
        ),
      ],
      child: child,
    );
  }
}

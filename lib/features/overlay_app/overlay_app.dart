import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/loading_widget.dart';
import '../../widgets/overlay_window.dart';
import '../message_channels/message_from_main_receiver/bloc/message_from_main_receiver_bloc.dart';
import '../message_channels/message_from_main_receiver/message_from_main_receiver.dart';
import 'bloc/overlay_app_bloc.dart';

class OverlayApp extends StatelessWidget {
  const OverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => OverlayAppBloc()..add(const OverlayAppStarted()),
        ),
        BlocProvider(
          create: (context) => MessageFromMainReceiverBloc()..add(const MessageFromMainReceiverStarted()),
        ),
      ],
      child: Builder(builder: (context) {
        final windowSettings = context.select(
          (MessageFromMainReceiverBloc bloc) => bloc.state.settings,
        );

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(),
          home: MessageFromMainReceiver(
            child: windowSettings == null
                ? const LoadingWidget()
                : Scaffold(
                    backgroundColor: Colors.black.withOpacity((windowSettings.opacity?.toInt() ?? 50) / 100),
                    body: OverlayWindow(settings: windowSettings),
                  ),
          ),
        );
      }),
    );
  }
}

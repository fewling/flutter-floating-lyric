import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../message_channels/message_from_main_receiver/bloc/message_from_main_receiver_bloc.dart';
import '../message_channels/message_from_main_receiver/message_from_main_receiver.dart';
import '../message_channels/message_to_main_sender/bloc/message_to_main_sender_bloc.dart';
import '../message_channels/message_to_main_sender/message_to_main_sender.dart';
import '../overlay_window/overlay_window.dart';
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
        BlocProvider(
          create: (context) => MessageToMainSenderBloc()..add(const MessageToMainSenderStarted()),
        ),
      ],
      child: const MaterialApp(
        home: MessageFromMainReceiver(
          child: MessageToMainSender(
            child: OverlayWindow(),
          ),
        ),
      ),
    );
  }
}

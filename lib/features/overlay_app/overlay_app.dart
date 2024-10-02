import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../service/message_channels/to_main_message_service.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/overlay_window.dart';
import '../message_channels/message_from_main_receiver/bloc/message_from_main_receiver_bloc.dart';
import 'bloc/overlay_app_bloc.dart';

class OverlayApp extends StatelessWidget {
  const OverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => OverlayAppBloc(
            toMainMessageService: ToMainMessageService(),
          )..add(const OverlayAppStarted()),
        ),
        BlocProvider(
          create: (context) => MessageFromMainReceiverBloc()..add(const MessageFromMainReceiverStarted()),
        ),
      ],
      child: Builder(builder: (context) {
        final windowSettings = context.select(
          (MessageFromMainReceiverBloc bloc) => bloc.state.settings,
        );
        final appColor = windowSettings?.appColorScheme;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: appColor == null ? null : Color(appColor),
            brightness: (windowSettings?.isLight ?? true) ? Brightness.light : Brightness.dark,
          ),
          home: Builder(builder: (context) {
            if (windowSettings == null) {
              return const LoadingWidget();
            } else {
              return Scaffold(
                // backgroundColor: Colors.black.withOpacity((windowSettings.opacity?.toInt() ?? 50) / 100),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(
                      (windowSettings.opacity?.toInt() ?? 50) / 100,
                    ),
                body: InkWell(
                  onTap: () => context.read<OverlayAppBloc>().add(const WindowTouched()),
                  child: OverlayWindow(
                    settings: windowSettings,
                    onCloseTap: () => context.read<OverlayAppBloc>().add(const CloseRequested()),
                    // debugText: 'AppColor: $appColor',
                    debugText:
                        windowSettings.showLyricOnly != null ? 'LyricOnly: ${windowSettings.showLyricOnly}' : 'null',
                  ),
                ),
              );
            }
          }),
        );
      }),
    );
  }
}

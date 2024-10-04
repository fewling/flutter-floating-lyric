import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../service/message_channels/to_main_message_service.dart';
import '../../service/platform_methods/layout_channel_service.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/overlay_window.dart';
import '../message_channels/message_from_main_receiver/bloc/message_from_main_receiver_bloc.dart';
import 'bloc/overlay_app_bloc.dart';

final rootKey = GlobalKey();

class OverlayApp extends StatefulWidget {
  const OverlayApp({super.key});

  @override
  State<OverlayApp> createState() => _OverlayAppState();
}

class _OverlayAppState extends State<OverlayApp> {
  @override
  Widget build(BuildContext rootContext) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (context) => OverlayAppBloc(
              toMainMessageService: ToMainMessageService(),
              layoutChannelService: LayoutChannelService(),
            )..add(const OverlayAppStarted()),
          ),
          BlocProvider(
            lazy: false,
            create: (context) => MessageFromMainReceiverBloc()..add(const MessageFromMainReceiverStarted()),
          ),
        ],
        child: Builder(builder: (context) {
          _updateSize(rootContext, context);

          final windowSettings = context.select(
            (MessageFromMainReceiverBloc bloc) => bloc.state.settings,
          );

          return Theme(
            data: ThemeData(
              colorSchemeSeed: windowSettings?.appColorScheme == null ? null : Color(windowSettings!.appColorScheme),
              brightness: windowSettings?.isLight ?? true ? Brightness.light : Brightness.dark,
            ),
            child: Material(
              color: Colors.transparent,
              child: Builder(
                builder: (context) => Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity((windowSettings?.opacity?.toInt() ?? 50) / 100),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Builder(
                    builder: (context) => SizedBox(
                      width: windowSettings?.width ?? 200,
                      height: double.infinity,
                      child: windowSettings == null
                          ? const LoadingWidget()
                          : OverlayWindow(
                              settings: windowSettings,
                              onCloseTap: () => context.read<OverlayAppBloc>().add(const CloseRequested()),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  void _updateSize(BuildContext rootContext, BuildContext blocContext) {
    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      final box = rootKey.currentContext?.findRenderObject() as RenderBox?;
      if (box == null) return;

      final view = View.of(rootContext);
      final pxRatio = view.devicePixelRatio;

      final width = box.getMaxIntrinsicWidth(double.infinity);
      final height = box.getMaxIntrinsicHeight(width);

      blocContext.read<OverlayAppBloc>().add(WindowResized(
            width: (width + 0.3) * pxRatio,
            height: (height + 10) * pxRatio,
          ));
    });
  }
}

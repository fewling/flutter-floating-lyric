import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../service/message_channels/to_main_message_service.dart';
import '../../service/platform_methods/layout_channel_service.dart';
import '../message_channels/message_from_main_receiver/bloc/message_from_main_receiver_bloc.dart';
import 'bloc/overlay_app_bloc.dart';
import 'overlay_window/bloc/overlay_window_bloc.dart';
import 'overlay_window/overlay_window.dart';

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
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => OverlayAppBloc()..add(const OverlayAppStarted()),
          ),
          BlocProvider(
            create: (context) => OverlayWindowBloc(
              toMainMessageService: ToMainMessageService(),
              layoutChannelService: LayoutChannelService(),
            )..add(const OverlayWindowStarted()),
          ),
          BlocProvider(
            lazy: false,
            create: (context) => MessageFromMainReceiverBloc()..add(const MessageFromMainReceiverStarted()),
          ),
        ],
        child: BlocListener<MessageFromMainReceiverBloc, MessageFromMainReceiverState>(
          listenWhen: (previous, current) => previous.settings?.ignoreTouch != current.settings?.ignoreTouch,
          listener: (context, state) {
            final ignore = state.settings?.ignoreTouch;
            if (ignore == null || !ignore) {
              // context.read<OverlayWindowBloc>().add(const LockToggled(false));
            } else {
              context.read<OverlayWindowBloc>().add(const LockToggled(true));
            }
          },
          child: Builder(builder: (context) {
            _updateSize(rootContext, context);

            final appColor = context.select((MessageFromMainReceiverBloc b) => b.state.settings?.appColorScheme);
            final fontFamily = context.select((MessageFromMainReceiverBloc b) => b.state.settings?.fontFamily);
            final isLight = context.select((MessageFromMainReceiverBloc b) => b.state.settings?.isLight);
            final width = context.select((MessageFromMainReceiverBloc b) => b.state.settings?.width);

            // Mark these here to trigger window resize
            context.select((MessageFromMainReceiverBloc b) => b.state.settings?.showLine2);
            context.select((MessageFromMainReceiverBloc b) => b.state.settings?.showProgressBar);
            context.select((MessageFromMainReceiverBloc b) => b.state.settings?.showMillis);
            context.select((MessageFromMainReceiverBloc b) => b.state.settings?.fontSize);
            context.select((MessageFromMainReceiverBloc b) => b.state.settings?.line1);
            context.select((MessageFromMainReceiverBloc b) => b.state.settings?.line2);

            return Theme(
              data: ThemeData(
                textTheme: fontFamily == null || fontFamily.isEmpty ? null : GoogleFonts.getTextTheme(fontFamily),
                colorSchemeSeed: appColor == null ? null : Color(appColor),
                brightness: isLight ?? true ? Brightness.light : Brightness.dark,
              ),
              child: SizedBox(
                width: width ?? 200,
                height: double.infinity,
                child: OverlayWindow(
                  isLyricOnly: context.select((OverlayWindowBloc b) => b.state.isLyricOnly),
                  onCloseTap: () => context.read<OverlayWindowBloc>().add(const CloseRequested()),
                  onWindowTap: () => context.read<OverlayWindowBloc>().add(const WindowTapped()),
                ),
              ),
            );
          }),
        ),
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

      blocContext.read<OverlayWindowBloc>().add(WindowResized(
            width: (width + 0.3) * pxRatio,
            height: (height + 2) * pxRatio,
          ));
    });
  }
}

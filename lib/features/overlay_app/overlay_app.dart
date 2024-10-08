import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../gen/assets.gen.dart';
import '../../service/message_channels/to_main_message_service.dart';
import '../../service/platform_methods/layout_channel_service.dart';
import '../../utils/logger.dart';
import '../message_channels/message_from_main_receiver/bloc/message_from_main_receiver_bloc.dart';
import 'bloc/overlay_app_bloc.dart';
import 'overlay_window/bloc/overlay_window_bloc.dart';
import 'overlay_window/overlay_window.dart';

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
            final isMinimized = context.select((OverlayAppBloc b) => b.state.isMinimized);

            _updateSize(rootContext, context, isMinimized);

            final appColor = context.select((MessageFromMainReceiverBloc b) => b.state.settings?.appColorScheme);
            final fontFamily = context.select((MessageFromMainReceiverBloc b) => b.state.settings?.fontFamily);
            final isLight = context.select((MessageFromMainReceiverBloc b) => b.state.settings?.isLight);

            // Mark the following to trigger rebuild when these values change
            final isLyricOnly = context.select((OverlayWindowBloc b) => b.state.isLyricOnly);
            final line1 = context.select((MessageFromMainReceiverBloc b) => b.state.settings?.line1);
            final line2 = context.select((MessageFromMainReceiverBloc b) => b.state.settings?.line2);
            final position = context.select((MessageFromMainReceiverBloc b) => b.state.settings?.position);
            final showBar = context.select((MessageFromMainReceiverBloc b) => b.state.settings?.showProgressBar);
            final fontSize = context.select((MessageFromMainReceiverBloc b) => b.state.settings?.fontSize);
            final title = context.select((MessageFromMainReceiverBloc b) => b.state.settings?.title);

            return Theme(
              data: ThemeData(
                textTheme: fontFamily == null || fontFamily.isEmpty ? null : GoogleFonts.getTextTheme(fontFamily),
                colorSchemeSeed: appColor == null ? null : Color(appColor),
                brightness: isLight ?? true ? Brightness.light : Brightness.dark,
              ),
              child: isMinimized
                  ? SizedBox(
                      height: 64,
                      width: 64,
                      child: Material(
                        color: Color(appColor ?? Colors.purple.value),
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => context.read<OverlayAppBloc>().add(const MaximizeRequested()),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(Assets.launcherIcon.appIcon.path),
                          ),
                        ),
                      ),
                    )
                  : const OverlayWindow(),
            );
          }),
        ),
      ),
    );
  }

  void _updateSize(BuildContext rootContext, BuildContext blocContext, bool isMinimized) {
    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      final box = rootContext.findRenderObject() as RenderBox?;
      if (box == null) {
        logger.e('Root box is null. Cannot update size.');
        blocContext.read<OverlayWindowBloc>().add(const WindowResized(width: 50, height: 50));
        return;
      }

      final view = View.of(rootContext);
      final pxRatio = view.devicePixelRatio;

      final width = box.getMaxIntrinsicWidth(isMinimized ? 64 : double.infinity);
      final height = box.getMaxIntrinsicHeight(width);

      blocContext.read<OverlayWindowBloc>().add(WindowResized(
            width: (width + 0.3) * pxRatio,
            height: (height + 2) * pxRatio,
          ));
    });
  }
}
